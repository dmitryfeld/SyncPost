/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.df.syncpost.dbservice;

import java.util.Collections;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 *
 * @author dmitryfeld
 */
public class DFSPDAOMap {
    protected static Map<String,String> MAP;
    protected static List<String> LITERALS;
    public DFSPDAOMap() {
        if (null == DFSPDAOMap.MAP) {
            Map<String, String> result = new HashMap<String,String>();
            result.put("authorizationId","AUTHORIZATION_ID");
            result.put("credentialsId","CREDENTIALS_ID");
            result.put("token","TOKEN");
            result.put("createdTime","CREATED_TIME");
            result.put("expiredTime","EXPIRED_TIME");

            result.put("credentialsId","CREDENTIALS_ID");
            result.put("memberName","MEMBER_NAME");
            result.put("password","PASSWORD");

            result.put("memberId","MEMBER_ID");
            result.put("memberName","MEMBER_NAME");
            result.put("firstName","FIRST_NAME");
            result.put("lastName","LAST_NAME");
            result.put("displayName","DISPLAY_NAME");
            result.put("comment","COMMENT");

            DFSPDAOMap.MAP = Collections.unmodifiableMap(result);
        }
        if (null == DFSPDAOMap.LITERALS) {
            List<String> result = new LinkedList<String>();
            result.add("MEMBER_NAME");
            result.add("FIRST_NAME");
            result.add("LAST_NAME");
            result.add("DISPLAY_NAME");
            result.add("COMMENT");
            result.add("PASSWORD");
            result.add("TOKEN");
            
            DFSPDAOMap.LITERALS = Collections.unmodifiableList(result);
        }
    }
    public String mapP2T(String propertyName) {
        String result = null;
        if (null != propertyName) {
            result = DFSPDAOMap.MAP.get(propertyName);
        }
        return result;
    }
    public String mapT2P(String tableFieldName) {
        String result = null;
        if (null != tableFieldName) {
            Set<String> keys = DFSPDAOMap.MAP.keySet();
            String pT;
            for (String pN : keys) {
                pT = DFSPDAOMap.MAP.get(pN);
                if (null != pT) {
                    if (pT.equals(tableFieldName)) {
                        result = pN;
                        break;
                    }
                }
            }
        }
        return result;
    }
    public boolean isLiteral(String columnName) {
        boolean result = false;
        if (null != columnName) {
            result = DFSPDAOMap.LITERALS.contains(columnName);
        }
        return result;
    }
}
