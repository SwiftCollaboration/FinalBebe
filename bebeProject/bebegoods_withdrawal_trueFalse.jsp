<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	request.setCharacterEncoding("utf-8");
	String trueFalseOfPassword = request.getParameter("trueFalseOfPassword");


	String url_mysql = "jdbc:mysql://localhost/bebegoods?serverTimezone=UTC&characterEncoding=utf8&useSSL=FALSE";
 	String id_mysql = "root";
 	String pw_mysql = "qwer1234";

	PreparedStatement ps = null;

String select = "SELECT IF(COUNT(*), 'true', 'false') AS trueFalseOfPassword \n";
String from = "FROM user \n";
String where = "WHERE password = ? \n";


    int count = 0;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
        Statement stmt_mysql = conn_mysql.createStatement();

	ps = conn_mysql.prepareStatement(select + from + where);
	ps.setString(1, trueFalseOfPassword);
	
        ResultSet rs = ps.executeQuery(); // &quot;
%>
  	[
<%
        while (rs.next()) {
            if (count == 0) {

            }else{
%>
            , 
<%           
            }
            count++;                 
%>
			{
			"trueFalseOfPassword" : "<%=rs.getString(1) %>"
			}
<%		
        }
%>
		  ]
<%		
        conn_mysql.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
	
%>
