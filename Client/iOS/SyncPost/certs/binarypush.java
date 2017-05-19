import javax.net.ssl.*;
import java.io.*;
import java.security.KeyStore;
import java.nio.ByteBuffer;
import java.util.Date;

public class binarypush {

    private static String token = "2874fb555f27e2475d1d166579b3e1d54b7dcf55045feb2ed41e73edc0dd3938";
    private static String host = "gateway.sandbox.push.apple.com";
    private static int port = 2195;
    private static String passphrase = "syncpost";
    private static String payload = "{\"aps\":{\"alert\":\"Testing.. (0)\",\"badge\":1,\"sound\":\"default\"}}";

    public static byte[] decode(String hex){
        String[] list=hex.split("(?<=\\G.{2})");
        ByteBuffer buffer= ByteBuffer.allocate(list.length);
        for(String str: list) {
            buffer.put((byte)Integer.parseInt(str,16));
        }
        return buffer.array();
    }
    
    public static byte[] deviceTokenItem(String deviceToken) {
        ByteBuffer bb = ByteBuffer.allocate(3 + 32);
        //bb.order( ByteOrder.BIG_ENDIAN)
        bb.put((byte) 1);
        bb.putShort((short) 32);
        bb.put(decode(deviceToken));
        return bb.array();
    };
    
    public static byte[] payloadItem(String payload) {
        byte[] payb =payload.getBytes();
        short payLength = (short)payb.length;
        ByteBuffer bb = ByteBuffer.allocate(3 + payLength);
        bb.put((byte) 2);
        bb.putShort((short)(payLength));
        bb.put(payb);
        return bb.array();
    };
    
    public static byte[] notificationIdItem(int id){
        ByteBuffer bb = ByteBuffer.allocate(3 + 4);
        bb.put((byte) 3);
        bb.putShort((short) 4);
        bb.putInt(id);
        return bb.array();
    };
    
    public static byte[] expirationDateItem(int time){
        ByteBuffer bb = ByteBuffer.allocate(3 + 4);
        bb.put((byte) 4);
        bb.putShort((short) 4);
        bb.putInt(time);
        return bb.array();
    };
    
    public static byte[] priorityItem(byte pr){
        ByteBuffer bb = ByteBuffer.allocate(3 + 1);
        bb.put((byte)5);
        bb.putShort((short) 1);
        bb.put((byte) pr);
        return bb.array();
    };
    
    public static void writeToAPNS(OutputStream stream,String deviceToken,String payload,int notificationId, int expirationIntervalSeconds, byte priority) throws IOException {
        Date d = new Date();
        int time = (int)((System.currentTimeMillis() + expirationIntervalSeconds) / 1000);
        byte[] token = deviceTokenItem(deviceToken);
        byte[] pay = payloadItem(payload);
        byte[] notification = notificationIdItem(notificationId);
        byte[] expiration = expirationDateItem(time);
        byte[] prior = priorityItem(priority);
        
        int frameLength = token.length + pay.length + notification.length + expiration.length + prior.length;
        
        stream.write(2);
        stream.write(frameLength);
        stream.write(token);
        stream.write(pay);
        stream.write(notification);
        stream.write(expiration);
        stream.write(prior);
    }

    public static byte[] getBytesFromInputStream(InputStream is) throws IOException
    {
        try (ByteArrayOutputStream os = new ByteArrayOutputStream();)
        {
            byte[] buffer = new byte[0xFFFF];

            for (int len; (len = is.read(buffer)) != -1;)
                os.write(buffer, 0, len);

            os.flush();

            return os.toByteArray();
        }
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
            
            writeToAPNS(outputstream,token,payload,0xBEAF,20,(byte)10);
            
            outputstream.flush();

            outputstream.close();


            
        } catch (Exception exception) {
            exception.printStackTrace();
        } finally {
            System.out.println("Completed");
        }
        
    }
}
