<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
  request.setCharacterEncoding("utf-8");
  String userEmail = request.getParameter("email");

//------
	String url_mysql = "jdbc:mysql://localhost/bebegoods?serverTimezone=UTC&characterEncoding=utf8&useSSL=FALSE";
 	String id_mysql = "root";
 	String pw_mysql = "qwer1234";
    String WhereDefault = "SELECT * FROM user WHERE email = '" + userEmail + "' ";
    int count = 0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
        Statement stmt_mysql = conn_mysql.createStatement();

        ResultSet rs = stmt_mysql.executeQuery(WhereDefault); // &quot;
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
			"email" : "<%=rs.getString(1) %>",
			"password" : "<%=rs.getString(2) %>",
			"nickname" : "<%=rs.getString(3) %>",
			"phone" : "<%=rs.getString(4) %>",
      "babyage" : "<%=rs.getString(5) %>",
      "rating" : "<%=rs.getString(6) %>",
      "signupdate" : "<%=rs.getString(7) %>",
			"signoutdate" : "<%=rs.getString(8) %>"
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
