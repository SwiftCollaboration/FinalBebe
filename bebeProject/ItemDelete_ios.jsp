<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%> 
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>       
<%
	request.setCharacterEncoding("utf-8");
	String itemCode_str = request.getParameter("itemCode");

	int itemCode = Integer.parseInt(itemCode_str);

	Date date = new Date();
	SimpleDateFormat sdformat = new SimpleDateFormat("yyyy-MM-dd");
	String deletedate = sdformat.format(date).toString();
		
//------
	String url_mysql = "jdbc:mysql://localhost/bebegoods?serverTimezone=UTC&characterEncoding=utf8&useSSL=FALSE";
	String id_mysql = "root";
	String pw_mysql = "qwer1234";

	int result = 0;

	PreparedStatement ps = null;
	try{
	    Class.forName("com.mysql.cj.jdbc.Driver");
	    Connection conn_mysql = DriverManager.getConnection(url_mysql,id_mysql,pw_mysql);
	    Statement stmt_mysql = conn_mysql.createStatement();
	
	    String query = "UPDATE item SET deletedate = ? WHERE itemcode = ?";

	    ps = conn_mysql.prepareStatement(query);
	    ps.setDate(1, java.sql.Date.valueOf(deletedate));
	    ps.setInt(2, itemCode);
	    
	    result = ps.executeUpdate();
		%>
		{
			"result" : "<%=result%>"
		}

<%		
	    conn_mysql.close();
	} 
	catch (Exception e){
%>
		{
			"result" : "<%=result%>"
		}
<%		
	    e.printStackTrace();
	} 
	
%>