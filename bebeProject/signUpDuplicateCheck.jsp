<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%
	request.setCharacterEncoding("utf-8");


  String result = null;
	String email = request.getParameter("email");
  String nickname = request.getParameter("nickname");

	String url_mysql = "jdbc:mysql://localhost/bebegoods?serverTimezone=Asia/Seoul&characterEncoding=utf8&useSSL=false";
	String id_mysql = "root";
	String pw_mysql = "qwer1234";

	PreparedStatement ps = null;
	try{
	    Class.forName("com.mysql.jdbc.Driver");
	    Connection conn_mysql = DriverManager.getConnection(url_mysql,id_mysql,pw_mysql);
		Statement stmt_mysql = conn_mysql.createStatement();

		String A = "SELECT count(*) as result FROM user WHERE email = ? OR nickname = ? AND signoutdate is null";

	    ps = conn_mysql.prepareStatement(A);
	    ps.setString(1, email);
	    ps.setString(2, nickname);

        ResultSet rs = ps.executeQuery();
        if(rs.next()){
          result = rs.getString("result");
        }
%>
		{
			"result" : "<%=result%>"
		}

<%
        conn_mysql.close();
    } catch (Exception e) {
%>
	{
		"result" : "<%=result%>"
	}
<%
        e.printStackTrace();
    }

%>
