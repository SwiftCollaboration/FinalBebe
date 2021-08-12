<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("utf-8");
	String itemcode = request.getParameter("itemcode");
    String score = request.getParameter("score");
    String scoreType = request.getParameter("scoreType");
	String sellerEmail = request.getParameter("sellerEmail");
    String buyerEmail = request.getParameter("buyerEmail");
    String scoreEmail = request.getParameter("scoreEmail");
    //==============
	String url_mysql = "jdbc:mysql://localhost/bebegoods?serverTimezone=UTC&characterEncoding=utf8&useSSL=FALSE";
 	String id_mysql = "root";
 	String pw_mysql = "qwer1234";
    String WhereDefault = "select EXISTS (select item_itemcode from deal where item_itemcode=" + itemcode + ")";
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
        
            String A = "insert into deal (buyer, seller, dealdate, " + scoreType + ", user_email, item_itemcode";
            String B = ") values (?, ?, now(), ?, ?, ?)";
        
            ps = conn_mysql.prepareStatement(A+B);
            ps.setString(1, buyerEmail);
            ps.setString(2, sellerEmail);
            ps.setString(3, score);
            ps.setString(4, sellerEmail);
            ps.setString(5, itemcode);
            
            ps.executeUpdate();
        
            conn_mysql.close();
        }catch(Exception e){
            e.printStackTrace();
        }
        updateTotalScore(score, scoreEmail);
            
        %> [{"result" : "insertSuccess"}] <%
    }else {
        String nullCheck = "";
        String WhereDefault2 = "select IFNULL(" + scoreType + ", 'noScore') from deal where item_itemcode=" + itemcode;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
            Statement stmt_mysql = conn_mysql.createStatement();
            ResultSet rs = stmt_mysql.executeQuery(WhereDefault2); // &quot;
            if(rs.next()) {
                nullCheck = rs.getString(1);
            }
            conn_mysql.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        if(nullCheck.equals("noScore")) {
            PreparedStatement ps = null;
            try{
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn_mysql = DriverManager.getConnection(url_mysql,id_mysql,pw_mysql);
                Statement stmt_mysql = conn_mysql.createStatement();
            
                String A = "update deal set " + scoreType + "=? where item_itemcode=?";
            
                ps = conn_mysql.prepareStatement(A);
                ps.setString(1, score);
                ps.setString(2, itemcode);
                
                ps.executeUpdate();
            
                conn_mysql.close();
                %> [{"result" : "updateSuccess"}] <%
                
            }catch(Exception e){
                e.printStackTrace();
            }            
            updateTotalScore(score, scoreEmail);
            
        }else {
            %> [{"result" : "alreadyExists"}] <%
        }
    }    
%>

<%!
    private void updateTotalScore(String score, String scoreEmail) {
        String url_mysql = "jdbc:mysql://localhost/bebegoods?serverTimezone=UTC&characterEncoding=utf8&useSSL=FALSE";
        String id_mysql = "root";
        String pw_mysql = "qwer1234";
        String WhereDefault1 = "select rating from user where email='" + scoreEmail + "'";
        int currentScore = 0;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
            Statement stmt_mysql = conn_mysql.createStatement();
            ResultSet rs = stmt_mysql.executeQuery(WhereDefault1); // &quot;
            if(rs.next()) {
                currentScore = rs.getInt(1);
            }
            conn_mysql.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        int totalScore = currentScore + Integer.parseInt(score);
        PreparedStatement ps = null;
        try{
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn_mysql = DriverManager.getConnection(url_mysql,id_mysql,pw_mysql);
            Statement stmt_mysql = conn_mysql.createStatement();
        
            String D = "update user set rating=? where email=?";
        
            ps = conn_mysql.prepareStatement(D);
            ps.setString(1, Integer.toString(totalScore));
            ps.setString(2, scoreEmail);
            
            ps.executeUpdate();
        
            conn_mysql.close();
        }catch(Exception e){
            e.printStackTrace();
        }
    }
%>
