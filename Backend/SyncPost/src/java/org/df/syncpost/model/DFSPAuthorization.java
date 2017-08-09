/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.df.syncpost.model;

import java.sql.ResultSet;
import java.util.Date;
import java.util.UUID;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author dmitryfeld
 */
public class DFSPAuthorization extends DFSPModel {
    public DFSPAuthorization(String authorizationId, String credentialsId) {
        super();
        Date now = new Date();
        super.setValueForKey(authorizationId, "authorizationId");
        super.setValueForKey(credentialsId, "credentialsId");
        super.setValueForKey(UUID.randomUUID().toString(), "token");
        super.setValueForKey("" + (now.getTime() / 1000), "createdTime");
        super.setValueForKey("0", "expiredTime");
        super.setValueForKey("3600","timeToLive");
    }
    public DFSPAuthorization(HttpServletRequest request) {
        super(request,new String[] {"authorizationId","credentialsId","token","createdTime","expiredTime","timeToLive"});
    }
    public DFSPAuthorization(ResultSet resultSet) {
        super(resultSet,new String[] {"authorizationId","credentialsId","token","createdTime","expiredTime","timeToLive"});
    }
    public String getAuthorizationId() {
        return super.getValue("authorizationId");
    }
    public String getCredentialsId() {
        return super.getValue("credentialsId");
    }
    public String getToken() {
        return super.getValue("token");
    }
    public String getCreatedTime() {
        return super.getValue("createdTime");
    }
    public String getExpiredTime() {
        return super.getValue("expiredTime");
    }
    public String getTimeToLive() {
        return super.getValue("timeToLive");
    }
    public Boolean isCurrent() {
        Boolean result = true;
        String created = this.getCreatedTime();
        String expired = this.getExpiredTime();
        if (null != created) {
            if (null != expired) {
                long cT = Long.valueOf(created);
                long rT = Long.valueOf(expired);
                if (rT > cT) {
                    result = false;
                }
            }
        }
        return result;
    }
    public void setExpired() {
        Date now = new Date();
        super.setValueForKey("" + (now.getTime() / 1000), "expiredTime");
    }
    @Override 
    public void injectPK(String pk) {
        super.setValueForKey(pk,"authorizationId");
    }
    @Override
    public String getTableName() {
        return "AUTHORIZATIONS";
    }
    @Override 
    public String getPrimaryKeyName() {
        return "AUTHORIZATION_ID";
    }
}
