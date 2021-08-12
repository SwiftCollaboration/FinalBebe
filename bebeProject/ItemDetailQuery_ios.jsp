<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	request.setCharacterEncoding("utf-8");
	String itemcode_str = request.getParameter("itemCode");
	int itemcode = Integer.parseInt(itemcode_str);

	String url_mysql = "jdbc:mysql://localhost/bebegoods?serverTimezone=UTC&characterEncoding=utf8&useSSL=FALSE";
 	String id_mysql = "root";
 	String pw_mysql = "qwer1234";
    String WhereDefault = "SELECT category, useage, itemtitle, itemcontent, itemimage, itemprice, usernickname, address, tag, dealcompletedate, deletedate, user_email FROM bebegoods.item WHERE itemcode = ";
    int count = 0;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
        Statement stmt_mysql = conn_mysql.createStatement();

        ResultSet rs = stmt_mysql.executeQuery(WhereDefault+itemcode); // &quot;
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
			"category" : "<%=rs.getString(1) %>",
			"useAge" : "<%=rs.getString(2) %>",
			"itemTitle" : "<%=rs.getString(3) %>", 
			"itemContent" : "<%=rs.getString(4) %>",
			"itemImage" : "<%=rs.getString(5) %>",	
			"itemPrice" : "<%=rs.getString(6) %>",
			"userNickname" : "<%=rs.getString(7) %>",
			"address" : "<%=rs.getString(8) %>",
			"tag" : "<%=rs.getString(9) %>",
			"dealCompleteDate" : "<%=rs.getString(10) %>",
			"deleteDate" : "<%=rs.getString(11) %>",
			"user_email" : "<%=rs.getString(12) %>"			
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
