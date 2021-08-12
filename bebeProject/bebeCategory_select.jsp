<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    request.setCharacterEncoding("utf-8");
	String category = request.getParameter("category");	
		
//------
	String url_mysql = "jdbc:mysql://localhost/bebegoods?serverTimezone=UTC&characterEncoding=utf8&useSSL=FALSE";
 	String id_mysql = "root";
 	String pw_mysql = "qwer1234";
   
    int count = 0;
    PreparedStatement ps = null;
   
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
        Statement stmt_mysql = conn_mysql.createStatement();
   
        String A = "select itemtitle, itemimage, address, useage, itemcode from item ";
	    String B = "where category = ? order by uploaddate desc";
   
   	    ps = conn_mysql.prepareStatement(A+B);

        ps.setString(1, category);

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
			"itemtitle" : "<%=rs.getString(1) %>",
			"itemimage" : "<%=rs.getString(2) %>",
			"address" : "<%=rs.getString(3) %>", 
			"useage" : "<%=rs.getString(4) %>",	
            "itemcode" : "<%=rs.getString(5) %>"
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
