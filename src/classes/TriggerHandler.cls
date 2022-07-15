public virtual class TriggerHandler {
    // static map of handlername, times run() was invoked
    private static Map<String, LoopCount> LoopCountMap;
    private static Set<String> BypassedHandlers;

    // the current Context of the trigger, overridable in tests
    @TestVisible
    private TriggerContext Context;

    // the current Context of the trigger, overridable in tests
    @TestVisible
    private Boolean IsTriggerExecuting;

    // static initialization
    static {
        LoopCountMap = new Map<String, LoopCount>();
        BypassedHandlers = new Set<String>();
    }

    // constructor
    public TriggerHandler() {
        this.setTriggerContext();
    }

    /***************************************
     * public instance methods
     ***************************************/

    // main method that will be called during execution
    public void run() {
        if (!validateRun()) {
            return;
        }

        addToLoopCount();

        // dispatch to the correct handler method
        if (this.Context == TriggerContext.BEFORE_INSERT) {
            this.beforeInsert();
        } else if (this.Context == TriggerContext.BEFORE_UPDATE) {
            this.beforeUpdate();
        } else if (this.Context == TriggerContext.BEFORE_DELETE) {
            this.beforeDelete();
        } else if (this.Context == TriggerContext.AFTER_INSERT) {
            this.afterInsert();
        } else if (this.Context == TriggerContext.AFTER_UPDATE) {
            this.afterUpdate();
        } else if (this.Context == TriggerContext.AFTER_DELETE) {
            this.afterDelete();
        } else if (this.Context == TriggerContext.AFTER_UNDELETE) {
            this.afterUndelete();
        }
    }

    public void setMaxLoopCount(Integer max) {
        String handler_name = getHandlerName();
        if (!TriggerHandler.LoopCountMap.containsKey(handler_name)) {
            TriggerHandler.LoopCountMap.put(handler_name, new LoopCount(max));
        } else {
            TriggerHandler.LoopCountMap.get(handler_name).setMax(max);
        }
    }

    public void clearMaxLoopCount() {
        this.setMaxLoopCount(-1);
    }

    /***************************************
     * public static methods
     ***************************************/

    public static void bypass(String handler_name) {
        TriggerHandler.BypassedHandlers.add(handler_name);
    }

    public static void clearBypass(String handler_name) {
        TriggerHandler.BypassedHandlers.remove(handler_name);
    }

    public static Boolean isBypassed(String handler_name) {
        return TriggerHandler.BypassedHandlers.contains(handler_name);
    }

    public static void clearAllBypasses() {
        TriggerHandler.BypassedHandlers.clear();
    }

    /***************************************
     * private instancemethods
     ***************************************/

    @TestVisible
    private void setTriggerContext() {
        this.setTriggerContext(null, false);
    }

    @TestVisible
    private void setTriggerContext(String ctx, Boolean test_mode) {
        if (!Trigger.isExecuting && !test_mode) {
            this.IsTriggerExecuting = false;
            return;
        } else {
            this.IsTriggerExecuting = true;
        }

        if ((Trigger.isExecuting && Trigger.isBefore && Trigger.isInsert) || (ctx != null && ctx == 'before insert')) {
            this.Context = TriggerContext.BEFORE_INSERT;
        } else if (
                (Trigger.isExecuting && Trigger.isBefore && Trigger.isUpdate) || (ctx != null && ctx == 'before update')
        ) {
            this.Context = TriggerContext.BEFORE_UPDATE;
        } else if (
                (Trigger.isExecuting && Trigger.isBefore && Trigger.isDelete) || (ctx != null && ctx == 'before delete')
        ) {
            this.Context = TriggerContext.BEFORE_DELETE;
        } else if (
                (Trigger.isExecuting && Trigger.isAfter && Trigger.isInsert) || (ctx != null && ctx == 'after insert')
        ) {
            this.Context = TriggerContext.AFTER_INSERT;
        } else if (
                (Trigger.isExecuting && Trigger.isAfter && Trigger.isUpdate) || (ctx != null && ctx == 'after update')
        ) {
            this.Context = TriggerContext.AFTER_UPDATE;
        } else if (
                (Trigger.isExecuting && Trigger.isAfter && Trigger.isDelete) || (ctx != null && ctx == 'after delete')
        ) {
            this.Context = TriggerContext.AFTER_DELETE;
        } else if (
                (Trigger.isExecuting && Trigger.isAfter && Trigger.isUndelete) || (ctx != null && ctx == 'after undelete')
        ) {
            this.Context = TriggerContext.AFTER_UNDELETE;
        }
    }

    // increment the loop count
    @TestVisible
    private void addToLoopCount() {
        String handler_name = getHandlerName();
        if (TriggerHandler.LoopCountMap.containsKey(handler_name)) {
            Boolean exceeded = TriggerHandler.LoopCountMap.get(handler_name).increment();
            if (exceeded) {
                Integer max = TriggerHandler.LoopCountMap.get(handler_name).max;
                throw new TriggerHandlerException(
                        'Maximum loop count of ' +
                                String.valueOf(max) +
                                ' reached in ' +
                                handler_name
                );
            }
        }
    }

    // make sure this trigger should continue to run
    @TestVisible
    private Boolean validateRun() {
        if (!this.IsTriggerExecuting || this.Context == null) {
            throw new TriggerHandlerException('Trigger handler called outside of Trigger execution');
        }
        if (TriggerHandler.BypassedHandlers.contains(getHandlerName())) {
            return false;
        }

        return true;
    }

    @TestVisible
    private String getHandlerName() {
        return String.valueOf(this).substring(0, String.valueOf(this).indexOf(':'));
    }

    /***************************************
     * Context methods
     ***************************************/

    // Context-specific methods for override
    @TestVisible
    protected virtual void beforeInsert() {
    }
    @TestVisible
    protected virtual void beforeUpdate() {
    }
    @TestVisible
    protected virtual void beforeDelete() {
    }
    @TestVisible
    protected virtual void afterInsert() {
    }
    @TestVisible
    protected virtual void afterUpdate() {
    }
    @TestVisible
    protected virtual void afterDelete() {
    }
    @TestVisible
    protected virtual void afterUndelete() {
    }

    /***************************************
     * inner classes
     ***************************************/

    // inner class for managing the loop count per handler
    @TestVisible
    private class LoopCount {
        private Integer Max;
        private Integer Count;

        public loopCount() {
            this.Max = 5;
            this.Count = 0;
        }

        public loopCount(Integer max) {
            this.Max = max;
            this.Count = 0;
        }

        public Boolean increment() {
            this.Count++;
            return this.exceeded();
        }

        public Boolean exceeded() {
            if (this.Max < 0) {
                return false;
            }
            if (this.Count > this.max) {
                return true;
            }
            return false;
        }

        public Integer getMax() {
            return this.Max;
        }

        public Integer getCount() {
            return this.Count;
        }

        public void setMax(Integer max) {
            this.Max = Max;
        }
    }

    // possible trigger contexts
    @TestVisible
    private enum TriggerContext {
        BEFORE_INSERT,
        BEFORE_UPDATE,
        BEFORE_DELETE,
        AFTER_INSERT,
        AFTER_UPDATE,
        AFTER_DELETE,
        AFTER_UNDELETE
    }

    // exception class
    public class TriggerHandlerException extends Exception {
    }
}