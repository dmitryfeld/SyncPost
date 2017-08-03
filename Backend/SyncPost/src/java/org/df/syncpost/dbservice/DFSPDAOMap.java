/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.df.syncpost.dbservice;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author dmitryfeld
 */
public class DFSPDAOMap {
    protected final Map<String,String> map;
    public DFSPDAOMap() {
        Map<String, String> result = new HashMap<String,String>();
        result.put("authorizationId","AUTHORIZATION_ID");
        result.put("credentialsId","CREDENTIALS_ID");
        result.put("token","TOKEN");
        result.put("createdTime","CREATED_TIME");
        result.put("removedTime","REMOVED_TIME");
        result.put("isCurrent","IS_CURRENT");
        
        result.put("credentialsId","CREDENTIALS_ID");
        result.put("memberName","MEMBER_NAME");
        result.put("password","PASSWORD");
        
        result.put("memberId","MEMBER_ID");
        result.put("memberName","MEMBER_NAME");
        result.put("firstName","FIRST_NAME");
        result.put("lastName","LAST_NAME");
        result.put("displayName","DISPLAY_NAME");
        result.put("description","DESCRIPTION");
        
        result.put("description","DESCRIPTION");
        this.map = Collections.unmodifiableMap(result);
    }
}
