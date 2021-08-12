<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="javax.mail.*"
import="javax.activation.FileDataSource"
import="javax.activation.DataSource"
import="java.util.Properties"
import="javax.mail.Message"
import="javax.mail.internet.InternetAddress"
import="javax.mail.Session"
import="javax.mail.Transport"
import="javax.mail.PasswordAuthentication"
import="javax.mail.internet.MimeMultipart"
import="javax.mail.internet.MimeMessage"
import="javax.activation.DataHandler"
import="javax.mail.internet.MimeUtility"
%>
<%
// mail server 설정
  final String host = "smtp.gmail.com";
  final String user = "jo.dev1223@gmail.com"; // 자신의 네이버 계정
  final String password = "hogang1223";// 자신의 네이버 패스워드

// ----------------- request
  request.setCharacterEncoding("utf-8");
// 메일 받을 주소
  String to_email = request.getParameter("email");
// 임시 비밀번호
  String tempPassword = request.getParameter("password");

  String subject = "bebegoods 비밀번호 재설정";
  String message = "임시 비밀번호는 " + tempPassword + " 입니다.\n마이페이지에서 비밀번호를 재설정해주세요.";


  // ------------ SMTP 서버 정보 설정

  // SMTP 서버 정보를 설정한다.
  Properties prop = System.getProperties();
  prop.put("mail.smtp.host", host);
  //google - TLS : 587, SSL: 467
  prop.put("mail.smtp.port", 465);
  prop.put("mail.smtp.starttls.enable", "true");
  prop.put("mail.smtp.auth", "true");
  prop.put("mail.smtp.ssl.enable", "true");
  prop.put("mail.smtp.ssl.trust", "smtp.gmail.com");
  prop.put("mail.debug", "true");

  Session sess = Session.getInstance(prop, new javax.mail.Authenticator() {
    protected PasswordAuthentication getPasswordAuthentication() {
      return new PasswordAuthentication(user, password);
    }
  });

  // email 전송
  try {
    MimeMessage msg = new MimeMessage(sess);
    msg.setFrom(new InternetAddress(user));
    msg.addRecipient(Message.RecipientType.TO, new InternetAddress(to_email));
    msg.setSubject(subject);
    msg.setContent(message, "text/html;charset=UTF-8");

    Transport.send(msg);

  }catch(Exception e){
    	out.println(e);
  }

%>
