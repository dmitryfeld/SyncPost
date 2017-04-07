import javax.net.ssl.*;
import java.io.*;
import java.security.KeyStore;
import java.nio.ByteBuffer;


public class simplepush {

    private static String token = "603bba3c8940e8aa7eb1c7a653580e7ae1d862fcdf0a484cb11e0c3f2c2ce62d";
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
            
            char[] t = token.toCharArray();
            byte[] b = decode(token);
            
            OutputStream outputstream = sslSocket.getOutputStream();
            
            outputstream.write(0);
            outputstream.write(0);
            outputstream.write(32);
            outputstream.write(b);
            outputstream.write(0);
            outputstream.write(payload.length());
            outputstream.write(payload.getBytes());
            
            outputstream.flush();
            outputstream.close();
            
        } catch (Exception exception) {
            exception.printStackTrace();
        } finally {
            System.out.println("Completed");
        }
        
    }
}
