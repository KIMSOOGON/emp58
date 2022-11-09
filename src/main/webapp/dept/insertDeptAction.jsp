<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	// 1. 요청분석
	request.setCharacterEncoding("utf-8"); // 한글 인코딩
	String deptNo = request.getParameter("deptNo");
	String deptName = request.getParameter("deptName");
	if(deptNo==null || deptName==null || deptNo.equals("") || deptName.equals("")){ // 안전장치 코드
		response.sendRedirect(request.getContextPath()+"/dept/insertDeptForm.jsp");
		return;
	}
	
	// 2. 요청처리
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("인서트액션 드라이버성공"); // 디버깅
	Connection conn = DriverManager.getConnection(
			
			"jdbc:mariadb://localhost:3306/employees","root","java1234");
	System.out.println("인서트액션 conn 성공 : "+conn);
	String sql = "INSERT INTO departments(dept_no, dept_name) values(?,?)";
	PreparedStatement stmt = conn.prepareStatement(sql);
	System.out.println("인서트액션 쿼리생성 성공");
	
	System.out.println(deptNo); // 디버깅
	System.out.println(deptName); // 디버깅
	
	stmt.setString(1,deptNo);
	stmt.setString(2,deptName);
	
	int row = stmt.executeUpdate();
	if(row==1){ // 디버깅
		System.out.println("성공");
	} else {
		System.out.println("실패");
	}
	
	// 3. 출력
	response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp");
%>