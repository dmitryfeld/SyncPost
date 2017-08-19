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
public class DFSPSignonRequest extends DFSPModel {
    public DFSPSignonRequest(HttpServletRequest request) {
        super(request,new String[] {"credentialsId","memberName","password","token"});
    }
    public DFSPSignonRequest(ResultSet resultSet) {
        super(resultSet,new String[] {"credentialsId","memberName","password","token"});
    }
    public String getCredentialsId() {
        return super.getValue("credentialsId");
    }
    public String getMemberName() {
        return super.getValue("memberName");
    }
    public String getPassword() {
        return super.getValue("password");
    }
    public String getTokend() {
        return super.getValue("token");
    }
    @Override 
    public void injectPK(String pk) {
        super.setValueForKey(pk,"");
    }
    @Override
    public String getTableName() {
        return "";
    }
    @Override 
    public String getPrimaryKeyName() {
        return "";
    }
}
