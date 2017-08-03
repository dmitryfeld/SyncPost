/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.df.syncpost.dbservice;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Collections;
import java.util.LinkedList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.df.syncpost.model.DFSPMember;

/**
 *
 * @author dmitryfeld
 */
public class DFSPDBMember {
    protected DFSPDAO dao;
    public DFSPDBMember() {
        try {
            this.dao = new DFSPDAO("jdbc:derby://localhost:1527/people");        
        } catch (SQLException ex) {
            Logger.getLogger(DFSPDBSeed.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    public List<DFSPMember> members() {
        List<DFSPMember> result = Collections.synchronizedList(new LinkedList<DFSPMember>());
        try {
            Connection connection = this.dao.open();
            connection.setTransactionIsolation(Connection.TRANSACTION_READ_COMMITTED);
            Statement select = connection.createStatement();
            ResultSet members = select.executeQuery("select * from MEMBERS");
            DFSPMember member;
            while (members.next()) {
                member = new DFSPMember(members);
                result.add(member);
            }
            this.dao.close(connection);
        } catch (SQLException ex) {
            Logger.getLogger(DFSPDBSeed.class.getName()).log(Level.SEVERE, null, ex);
        }
        return result;
    }
    public DFSPMember members(String memberName) {
        DFSPMember result = null;
        try {
            Connection connection = this.dao.open();
            connection.setTransactionIsolation(Connection.TRANSACTION_READ_COMMITTED);
            Statement select = connection.createStatement();
            ResultSet members = select.executeQuery("select * from MEMBERS where MEMBER_NAME is " + memberName);
            DFSPMember member;
            while (members.next()) {
                result = new DFSPMember(members);
            }
            this.dao.close(connection);
        } catch (SQLException ex) {
            Logger.getLogger(DFSPDBSeed.class.getName()).log(Level.SEVERE, null, ex);
        }
        return result;
    }
    public void addMember(DFSPMember member) {
        
    }
    public void saveMember(DFSPMember member) {
        
    }
}
