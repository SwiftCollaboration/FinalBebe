<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%
	request.setCharacterEncoding("utf-8");

	String nickname = null;
	String email = request.getParameter("email");
	String password = request.getParameter("password");

	String url_mysql = "jdbc:mysql://localhost/bebegoods?serverTimezone=Asia/Seoul&characterEncoding=utf8&useSSL=false";
	String id_mysql = "root";
	String pw_mysql = "qwer1234";

	PreparedStatement ps = null;
	try{
	    Class.forName("com.mysql.jdbc.Driver");
	    Connection conn_mysql = DriverManager.getConnection(url_mysql,id_mysql,pw_mysql);
		Statement stmt_mysql = conn_mysql.createStatement();

		String A = "SELECT email, password, nickname FROM user WHERE email = ? AND signoutdate is null";

	    ps = conn_mysql.prepareStatement(A);
	    ps.setString(1, email);

        ResultSet rs = ps.executeQuery();
        if(rs.next()){
        	if(rs.getString("email").equals(email) && rs.getString("password").equals(password)){
        		nickname = rs.getString("nickname");
        	}else{
        		nickname = "loginFail";
        	}
        }else{
        	nickname = "loginError";
        }

%>
		{
			"nickname" : "<%=nickname%>"
		}

<%
        conn_mysql.close();
    } catch (Exception e) {
%>
	{
		"nickname" : "<%=nickname%>"
	}
<%
        e.printStackTrace();
    }

%>
