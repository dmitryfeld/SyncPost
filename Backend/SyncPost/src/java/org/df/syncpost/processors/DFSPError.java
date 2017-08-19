/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.df.syncpost.processors;

/**
 *
 * @author dmitryfeld
 */
public class DFSPError {
    public enum ERRORS {
        INVALID_REQUEST("3000","Invalid request format"),
        INVALID_MEMBER_NAME("3001","Invalid Member Name"),
        INVALID_CREDENTIALS("3002","Invalid Credentials"),
        MEMBER_NOT_FOUND("3003","Member is not found"),
        MEMBER_NOT_AUTHORIZED("3004","Member is not authorized"),
        MEMBER_IS_ALREADY_AUTHORIZED("3005","Member is already authorized"),
        AUTHORIZATION_NOT_FOUND("3006","Authorization not found"),
        INVALID_AUTHORIZATION("3007","Invalid Authorization"),
        INVALID_AUTHORIZATION_ID("3008","Invalid Authorization ID");
        private final String code;
        private final String message;
        ERRORS(String code,String message) {
            this.code = code;
            this.message = message;
        }
        public String getCode() {
            return this.code;
        }
        public String getMessage() {
            return this.message;
        }
        public String toJSON() {
            return "{\"code\":\"" + this.code + "\",\"message\":\"" + this.message + "\"}";
        }
    }
}
