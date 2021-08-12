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

String select = "SELECT IF(COUNT(*), 'true', 'false') AS countOfDeal \n";
String from = "FROM deal AS a INNER JOIN user AS b ON a.user_email = b.email INNER JOIN item AS c ON a.item_itemcode = c.itemcode \n";
String where = "WHERE ((a.buyer = ?) OR (a.seller = ?)) AND c.dealcompletedate IS NULL";


    int count = 0;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
        Statement stmt_mysql = conn_mysql.createStatement();

	ps = conn_mysql.prepareStatement(select + from + where);
	ps.setString(1, userEmail);
	ps.setString(2, userEmail);
	
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
			"countOfDeal" : "<%=rs.getString(1) %>"
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
