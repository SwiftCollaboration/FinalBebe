<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="java.io.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%> 
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>       
<%
	String SavePath = "/Library/Tomcat/webapps/ROOT/bebeProject/image/";
	int sizeLimit = 10 * 1024 * 1024;
	MultipartRequest multi = new MultipartRequest(request, SavePath, sizeLimit, new DefaultFileRenamePolicy());
	
	File file = multi.getFile("file");

	String name = multi.getParameter("name");

	request.setCharacterEncoding("utf-8");
	String itemCode_str = request.getParameter("itemCode");
	String category = request.getParameter("category");
	String useage = request.getParameter("useAge");
	String itemtitle = request.getParameter("itemTitle");
	String itemcontent = request.getParameter("itemContent");	
	String itemprice_str = request.getParameter("itemPrice");
	String address = request.getParameter("address");	
	String tag = request.getParameter("tag");

	int itemCode = Integer.parseInt(itemCode_str);
	int itemprice = Integer.parseInt(itemprice_str);
		
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
	
	    String query = "UPDATE bebegoods.item SET category=?, useage=?, itemtitle=?, itemcontent=?, itemimage=?, itemprice=?, address=?, tag=? WHERE itemcode = ?";

	    ps = conn_mysql.prepareStatement(query);
	    ps.setString(1, category);
	    ps.setString(2, useage);
	    ps.setString(3, itemtitle);
	    ps.setString(4, itemcontent);
	    ps.setString(5, file.getName());
	    ps.setInt(6, itemprice);
	    ps.setString(7, address);
	    ps.setString(8, tag);
	    ps.setInt(9, itemCode);
	    
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