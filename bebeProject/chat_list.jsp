<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("utf-8");
	String email = request.getParameter("email");

    //==============

	String url_mysql = "jdbc:mysql://localhost/bebegoods?serverTimezone=UTC&characterEncoding=utf8&useSSL=FALSE";
 	String id_mysql = "root";
 	String pw_mysql = "qwer1234";
    String WhereDefault = "select roomcode, (select email from user where email=seller) as sellerEmail, (select nickname from user where email=seller) as sellerNickName, (select email from user where email=buyer) as buyerEmail, (select nickname from user where email=buyer) as buyerNickName, itemcode, itemtitle, itemimage, message, left(senddate, 10) as senddate "
                            + "from room "
                            + "inner join item on itemcode=item_itemcode "
                            + "inner join (select chat.room_roomcode, message, senddate from chat "
                            + "inner join (select room_roomcode, max(chatcode) as currentNo from chat group by room_roomcode) currentMessage "
                            + "where currentNo = chatcode) lastMessage "
                            + "on lastMessage.room_roomcode = room.roomcode "
                            + "where seller='" + email + "' or buyer='" + email + "' "
                            + "order by senddate desc";
    int count = 0;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
        Statement stmt_mysql = conn_mysql.createStatement();

        ResultSet rs = stmt_mysql.executeQuery(WhereDefault); // &quot;
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
			"roomcode" : "<%=rs.getInt(1) %>",
			"sellerEmail" : "<%=rs.getString(2) %>",
			"sellerNickName" : "<%=rs.getString(3) %>",
			"buyerEmail" : "<%=rs.getString(4) %>",
			"buyerNickName" : "<%=rs.getString(5) %>",
            "itemcode" : "<%=rs.getInt(6) %>",
            "itemtitle" : "<%=rs.getString(7) %>",
            "itemimage" : "<%=rs.getString(8) %>",
            "message" : "<%=rs.getString(9) %>",
            "senddate" : "<%=rs.getString(10) %>"
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
