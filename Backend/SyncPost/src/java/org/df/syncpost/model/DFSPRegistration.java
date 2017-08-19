/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.df.syncpost.model;

import java.sql.ResultSet;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author dmitryfeld
 */
public class DFSPRegistration extends DFSPModel {
    
    public DFSPRegistration(HttpServletRequest request) {
        super(request,new String[] {"registrationId","memberId","pushNotificationId"});
    }
    public DFSPRegistration(ResultSet resultSet) {
        super(resultSet,new String[] {"registrationId","memberId","pushNotificationId"});
    }
    public String getRegistryId() {
        return super.getValue("registrationId");
    }
    public String getMemberId() {
        return super.getValue("memberId");
    }
    public String getPushNotificationId() {
        return super.getValue("pushNotificationId");
    }
    @Override 
    public void injectPK(String pk) {
        super.setValueForKey(pk,"registrationId");
    }
    @Override
    public String getTableName() {
        return "REGISTRATIONS";
    }
    @Override 
    public String getPrimaryKeyName() {
        return "REGISTRATION_ID";
    }
}
