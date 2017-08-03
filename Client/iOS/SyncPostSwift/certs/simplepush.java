import javax.net.ssl.*;
import java.io.*;
import java.security.KeyStore;
import java.nio.ByteBuffer;


public class simplepush {

    private static String token = "701172dc0cbc497c7ade065fc3069fda55fafe1d0e4c52807c257bfd13a75961";
    private static String host = "gateway.sandbox.push.apple.com";
    private static int port = 2195;
    private static String passphrase = "syncpost";
    private static String payload = "{\"aps\":{\"alert\":\"Testing.. (0)\",\"badge\":1,\"sound\":\"default\"}}";

    public static byte[] decode(String hex){
        String[] list=hex.split("(?<=\\G.{2})");
        ByteBuffer buffer= ByteBuffer.allocate(list.length);
        for(String str: list)
            buffer.put((byte)Integer.parseInt(str,16));
        
        return buffer.array();
    }
    
    public static void writeToAPNS(OutputStream out,String deviceToken,String payload) throws IOException {
        byte[] b = decode(deviceToken);
        
        out.write(0);
        out.write(0);
        out.write(32);
        out.write(b);
        out.write(0);
        out.write(payload.length());
        out.write(payload.getBytes());
    }
    
    public static void main(String args[]) {
        System.out.println("test");
        
        try {
            KeyStore keyStore = KeyStore.getInstance("PKCS12");
            
            keyStore.load(simplepush.class.getResourceAsStream("SyncPostDevCert.p12"), passphrase.toCharArray());
            KeyManagerFactory keyMgrFactory = KeyManagerFactory.getInstance("SunX509");
            keyMgrFactory.init(keyStore, passphrase.toCharArray());
            
            SSLContext sslContext = SSLContext.getInstance("TLS");
            sslContext.init(keyMgrFactory.getKeyManagers(), null, null);
            SSLSocketFactory sslSocketFactory = sslContext.getSocketFactory();
            
            SSLSocket sslSocket = (SSLSocket) sslSocketFactory.createSocket(host, port);
            String[] cipherSuites = sslSocket.getSupportedCipherSuites();
            sslSocket.setEnabledCipherSuites(cipherSuites);
            sslSocket.startHandshake();
            
            OutputStream outputstream = sslSocket.getOutputStream();
            
            writeToAPNS(outputstream,token,payload);
            
            outputstream.flush();
            outputstream.close();
            
        } catch (Exception exception) {
            exception.printStackTrace();
        } finally {
            System.out.println("Completed");
        }
        
    }
}
