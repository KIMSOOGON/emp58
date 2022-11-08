<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import = "java.util.*"%>
<%@ page import = "vo.*" %>
<%
	// 1. 요청분석
	request.setCharacterEncoding("utf-8");
	String deptNo = request.getParameter("deptNo");
	String deptName = request.getParameter("deptName");
	
	// 2. 요청처리
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("수정Action 드라이버로딩완료");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","java1234");
	System.out.println("수정Action conn완료 : " +conn);
	String sql = "update departments set dept_name=? where dept_no=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	System.out.println("수정Action 쿼리생성 stmt : "+stmt);
	stmt.setString(1, deptName);
	stmt.setString(2, deptNo);
	
	int row = stmt.executeUpdate();
	if(row == 1){
		System.out.println("수정성공");
	} else {
		System.out.println("수정실패");
	}
	
	// 3. 출력
	response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp");
%>