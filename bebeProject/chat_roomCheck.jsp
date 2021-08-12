<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("utf-8");
	String seller = request.getParameter("seller");
    String buyer = request.getParameter("buyer");
    String itemcode = request.getParameter("itemcode");

    //==============

	String url_mysql = "jdbc:mysql://localhost/bebegoods?serverTimezone=UTC&characterEncoding=utf8&useSSL=FALSE";
 	String id_mysql = "root";
 	String pw_mysql = "qwer1234";
    String WhereDefault = "SELECT IFNULL(MAX(roomcode), 0) as result FROM room "
                        + "WHERE seller='" + seller + "' and buyer='" + buyer + "' and item_itemcode=" + itemcode;
    int count = 0;
    String result = "";
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
        Statement stmt_mysql = conn_mysql.createStatement();

        ResultSet rs = stmt_mysql.executeQuery(WhereDefault); // &quot;

        if(rs.next()) {
			result = rs.getString(1);
        }
        conn_mysql.close();

    } catch (Exception e) {
        e.printStackTrace();
    }

    if(result.equals("0")) {

        PreparedStatement ps = null;
        try{
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn_mysql = DriverManager.getConnection(url_mysql,id_mysql,pw_mysql);
            Statement stmt_mysql = conn_mysql.createStatement();
        
            String A = "insert into room (date, item_itemcode, seller, buyer";
            String B = ") values (now(),?,?,?)";
        
            ps = conn_mysql.prepareStatement(A+B);
            ps.setString(1, itemcode);
            ps.setString(2, seller);
            ps.setString(3, buyer);
            
            ps.executeUpdate();
        
            conn_mysql.close();
        }catch(Exception e){
            e.printStackTrace();
        }

        String WhereDefault1 = "select roomcode from room where seller='" + seller + "' and buyer='" + buyer + "' and item_itemcode=" + itemcode;
        int count1 = 0;
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
            Statement stmt_mysql = conn_mysql.createStatement();

            ResultSet rs = stmt_mysql.executeQuery(WhereDefault1); // &quot;
%>
        [ 
<%
            while (rs.next()) {
                if (count1 == 0) {

                }else{
%>
                , 
<%           
                }
                count1++;                 
%>
                {
                "roomcode" : "<%=rs.getString(1) %>"	
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

    }else {
%>
        [{"roomcode" : "<%=result%>"}]
<%
    }
%>
