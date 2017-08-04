/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.df.syncpost.model;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Iterator;
import javax.servlet.http.HttpServletRequest;
import org.df.syncpost.dbservice.DFSPDAOMap;

/**
 *
 * @author dmitryfeld
 */
public abstract class DFSPModel {
    private final HashMap<String,String> content;
    private final DFSPDAOMap map;
    public DFSPModel() {
        this.content = new HashMap<String,String>();
        this.map = new DFSPDAOMap();
    }
    public DFSPModel(DFSPModel model) {
        this.content = new HashMap<String,String>(model.content);
        this.map = new DFSPDAOMap();
    }
    public DFSPModel(HttpServletRequest request,String[] names) {
        this.content = new HashMap<String,String>();
        for (String name : names) {
            String value = request.getHeader(name);
            if (null != value) {
                this.content.put(name, value);
            }
        }
        this.map = new DFSPDAOMap();
    }
    public DFSPModel(ResultSet resultSet,String[] names) {
        this.content = new HashMap<String,String>();
        String nT;
        for (String name : names) {
            try {
                if (null != (nT = this.map.mapP2T(name))) {
                    String value = resultSet.getObject(nT,String.class);
                    if (null != value) {
                        this.content.put(name, value);
                    }
                }
            } catch (SQLException exception) {
                
            } finally {
                
            }
        }
        this.map = new DFSPDAOMap();
    }
    public String getValue(String key) {
        return this.content.get(key);
    }
    public abstract void injectPK(String pk);
    protected void setValueForKey(String value,String key) {
        if ((null != value) && (null != key)) {
            this.content.put(key, value);
        }
    }
    @Override
    public int hashCode() {
        int hash = 7;
        hash = 71 * hash + (this.content != null ? this.content.hashCode() : 0);
        return hash;
    }
    @Override
    public boolean equals(Object call) {
        if (!(call instanceof DFSPModel)) {
            return false;
        }
        DFSPModel obj = (DFSPModel)call;
        return this.content.equals(obj.content);
    }
    
    public String toJSON() {
        String result = "{";
        Iterator<String> iter = this.content.keySet().iterator();
        String key,value;
        while (iter.hasNext()) {
            key = iter.next();
            value = this.content.get(key);
            if (null != value) {
                result += "\"" + key + "\":" + value;
                if (iter.hasNext()) {
                    result += ",";
                }   
            }
        }
        result = "}";        
        return result;
    }
    public String toSQL_UPDATE() {
        String result = "";
        Iterator<String> iter = this.content.keySet().iterator();
        String propertyName,columnName,value;
        while (iter.hasNext()) {
            propertyName = iter.next();
            if (null != (columnName = this.map.mapP2T(propertyName))) {
                if (null != (value = this.content.get(propertyName))) {
                    result += (columnName + "=" + value);
                    if (iter.hasNext()) {
                        result += ",";
                    } 
                }
            }
        }       
        return result;
    }
    
    public String toSQL_INSERT() {
        String result = "";
        String columns = "";
        String values = "";
        Iterator<String> iter = this.content.keySet().iterator();
        String propertyName,columnName,value;
        int count = 0;
        while (iter.hasNext()) {
            propertyName = iter.next();
            if (null != (columnName = this.map.mapP2T(propertyName))) {
                if (null != (value = this.content.get(propertyName))) {
                    columns += columnName;
                    values += value;
                    if (iter.hasNext()) {
                        columns += ",";
                        values += ",";
                    } 
                    count ++;
                }
            }
        }      
        if ( 0 != count) {
            result = "(" + columns + ") values (" + values + ")";
        }
        return result;
    }
    
    public abstract String getTableName();
    
    protected final String string(String string) {
        if (null == string) {
            string = "";
        }
        return string;
    }
    
}
