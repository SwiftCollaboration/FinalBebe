<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	request.setCharacterEncoding("utf-8");
	String userEmail = request.getParameter("userEmail");


	String url_mysql = "jdbc:mysql://localhost/bebegoods?serverTimezone=UTC&characterEncoding=utf8&useSSL=FALSE";
 	String id_mysql = "root";
 	String pw_mysql = "qwer1234";

	PreparedStatement ps = null;


    String select = "SELECT c.itemimage, c.itemtitle, c.usernickname, c.address, c.useage, c.itemcode , a.sellerscore\n";
    String from = "FROM deal AS a INNER JOIN user AS b ON a.user_email = b.email INNER JOIN item AS c ON a.item_itemcode = c.itemcode \n";
    String where = "WHERE a.buyer = ? AND c.dealcompletedate IS NOT NULL";
    int count = 0;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
        Statement stmt_mysql = conn_mysql.createStatement();

	ps = conn_mysql.prepareStatement(select + from + where);
	ps.setString(1, userEmail);
	
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
			"itemimage" : "<%=rs.getString(1) %>",
			"itemtitle" : "<%=rs.getString(2) %>",
			"usernickname" : "<%=rs.getString(3) %>",
			"address" : "<%=rs.getString(4) %>",
			"useage" : "<%=rs.getString(5) %>",
			"itemcode" : "<%=rs.getString(6) %>",
			"itemScore" : "<%=rs.getString(7) %>"
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
