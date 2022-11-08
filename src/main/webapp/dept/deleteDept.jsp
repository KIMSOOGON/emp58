<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*"%>
<%@ page import = "vo.*" %>
<%
	// 1. 요청분석(Controller)
	request.setCharacterEncoding("utf-8");
	String deptNo = request.getParameter("deptNo");
	
	// 2. 업무처리(Model)
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("delete 드라이버 로딩 완료");
	
	Connection conn = DriverManager.getConnection(
			"jdbc:mariadb://localhost:3306/employees","root","java1234");
	System.out.println("delete 접속완료 conn : " + conn);
	
	String sql = "delete from departments where dept_no = ?";
	System.out.println("delete sql : "+sql);
	
	PreparedStatement stmt = conn.prepareStatement(sql);
	System.out.println("delete stmt : "+stmt);
	stmt.setString(1,deptNo);
	
	int row = stmt.executeUpdate();
	if(row==1){
		System.out.println("삭제완료");
	} else {
		System.out.println("삭제실패");
	}
	
	// 3. 출력
	response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp");
%>