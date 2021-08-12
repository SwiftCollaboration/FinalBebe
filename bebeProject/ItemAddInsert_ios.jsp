<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="java.io.*" %>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>        
<%
	String SavePath = "/Library/Tomcat/webapps/ROOT/bebeProject/image/";
	int sizeLimit = 10 * 1024 * 1024;
	MultipartRequest multi = new MultipartRequest(request, SavePath, sizeLimit, new DefaultFileRenamePolicy());
	
	File file = multi.getFile("file");

	String name = multi.getParameter("name");
	
	request.setCharacterEncoding("utf-8");
	String category = request.getParameter("category");
	String useage = request.getParameter("useAge");
	String itemtitle = request.getParameter("itemTitle");
	String itemcontent = request.getParameter("itemContent");	
		
	String itemprice_str = request.getParameter("itemPrice");
	String usernickname = request.getParameter("userNickname");	
	String address = request.getParameter("address");	
	String tag = request.getParameter("tag");
	String user_email= request.getParameter("user_email");

	int itemprice = Integer.parseInt(itemprice_str);	
	
	Date date = new Date();
	SimpleDateFormat sdformat = new SimpleDateFormat("yyyy-MM-dd");
	String uploaddate = sdformat.format(date).toString();
		
//------
	String url_mysql = "jdbc:mysql://localhost/bebegoods?serverTimezone=UTC&characterEncoding=utf8&useSSL=FALSE";
	String id_mysql = "root";
	String pw_mysql = "qwer1234";

	int result = 0; // 입력 확인 

	PreparedStatement ps = null;
	try{
	    Class.forName("com.mysql.cj.jdbc.Driver");
	    Connection conn_mysql = DriverManager.getConnection(url_mysql,id_mysql,pw_mysql);
	    Statement stmt_mysql = conn_mysql.createStatement();
	
	    String A = "insert into bebegoods.item (category, useage, itemtitle, itemcontent, itemimage, itemprice, usernickname, address, tag, uploaddate, user_email";
	    String B = ") values (?,?,?,?,?,?,?,?,?,?,?)";
	
	    ps = conn_mysql.prepareStatement(A+B);
	    ps.setString(1, category);
	    ps.setString(2, useage);
	    ps.setString(3, itemtitle);
	    ps.setString(4, itemcontent);
	    ps.setString(5, file.getName());
	    ps.setInt(6, itemprice);
	    ps.setString(7, usernickname);
	    ps.setString(8, address);
	    ps.setString(9, tag);
	    ps.setDate(10, java.sql.Date.valueOf(uploaddate));
	    ps.setString(11, user_email);
	    
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

