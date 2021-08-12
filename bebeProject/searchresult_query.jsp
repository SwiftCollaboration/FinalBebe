<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    String search = request.getParameter("search");

	String url_mysql = "jdbc:mysql://localhost/bebegoods?serverTimezone=UTC&characterEncoding=utf8&useSSL=FALSE";
 	String id_mysql = "root";
 	String pw_mysql = "qwer1234";
    String query = "SELECT itemcode, category, useage, itemtitle, itemimage, usernickname, address, tag, uploaddate FROM item ";
    String subQuery = "WHERE (itemtitle OR itemcontent LIKE '%" + search + "%') AND dealcompletedate IS NULL AND deletedate IS NULL";
    int count = 0;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
        Statement stmt_mysql = conn_mysql.createStatement();

        ResultSet rs = stmt_mysql.executeQuery(query + subQuery); // &quot;
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
			"itemcode" : "<%=rs.getInt(1) %>",
            "category" : "<%=rs.getString(2) %>",
			"useage" : "<%=rs.getString(3) %>",
            "itemtitle" : "<%=rs.getString(4) %>",
            "itemimage" : "<%=rs.getString(5) %>",
            "usernickname" : "<%=rs.getString(6) %>",
            "address" : "<%=rs.getString(7) %>",
			"tag" : "<%=rs.getString(8) %>",
            "uploaddate" : "<%=rs.getString(9) %>"	
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
