<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	request.setCharacterEncoding("utf-8");
	String email = request.getParameter("email");


	String url_mysql = "jdbc:mysql://localhost/bebegoods?serverTimezone=UTC&characterEncoding=utf8&useSSL=FALSE";
 	String id_mysql = "root";
 	String pw_mysql = "qwer1234";

	PreparedStatement ps = null;

	String select1 = "SELECT email, nickname, signupdate, ";
	String select2 = "CASE WHEN (SELECT sum(sellerscore) FROM deal WHERE buyer = ? GROUP BY buyer) is null THEN 0 ELSE (SELECT sum(sellerscore) FROM deal WHERE buyer = ? GROUP BY buyer) END + CASE WHEN (SELECT sum(buyerscore) FROM deal WHERE seller = ? GROUP BY seller) is null THEN 0 ELSE (SELECT sum(buyerscore) FROM deal WHERE seller = ? GROUP BY seller) END AS score \n";
	String from = "FROM user \n";
	String where = "WHERE email = ?";

    int count = 0;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
        Statement stmt_mysql = conn_mysql.createStatement();

	ps = conn_mysql.prepareStatement(select1 + select2 + from + where);
	ps.setString(1, email);
	ps.setString(2, email);
	ps.setString(3, email);
	ps.setString(4, email);
	ps.setString(5, email);

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
			"email" : "<%=rs.getString(1) %>",
			"nickname" : "<%=rs.getString(2) %>",
			"signupdate" : "<%=rs.getString(3) %>",
			"score" : "<%=rs.getString(4) %>"
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
