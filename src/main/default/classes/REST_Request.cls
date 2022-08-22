/**
 * Created by dominikbarchanski on 21/05/2022.
 */

global with sharing class REST_Request {

    public String operationType;
    public REST_HospitalDTO hospitalDTO;
    public String status;
    global REST_Request(String operationType, REST_HospitalDTO hospitalDTO, String status) {
        this.operationType = operationType;
        this.hospitalDTO = hospitalDTO;
        this.status = status;
    }
}