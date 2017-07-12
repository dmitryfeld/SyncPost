/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.df.syncpost.dbservice;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author dmitryfeld
 */
public class DFSPDBSeed {
    protected DFSPDAO dao;
    public DFSPDBSeed() {
        try {
            this.dao = new DFSPDAO("jdbc:derby://localhost:1527/service");        
        } catch (SQLException ex) {
            Logger.getLogger(DFSPDBSeed.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    public Integer nextSeed() {
        Integer result = -1;
        try {
            Connection connection = this.dao.open();
            connection.setTransactionIsolation(Connection.TRANSACTION_READ_COMMITTED);
            Statement select = connection.createStatement();
            ResultSet seeds = select.executeQuery("select * from SEED");
            PreparedStatement update = null;
            while (seeds.next()) {
                result = seeds.getInt(0);
            }
            if (-1 != result) {
                Integer next = result + 1;
                update = connection.prepareStatement("update SEED set SEED_ID = " + next);
            }
            connection.commit();
            this.dao.close(connection);
        } catch (SQLException ex) {
            Logger.getLogger(DFSPDBSeed.class.getName()).log(Level.SEVERE, null, ex);
        }
        return result;
    }
}
