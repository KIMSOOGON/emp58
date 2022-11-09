<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import = "java.util.*"%>
<%@ page import = "vo.*" %>
<%@ page import = "java.net.URLEncoder" %>
<%
	// 1. 요청분석
	request.setCharacterEncoding("utf-8");
	String deptNo = request.getParameter("deptNo");
	String deptName = request.getParameter("deptName");
	
	Department dept = new Department();
	dept.deptNo = deptNo;
	dept.deptName = deptName;
	
	// 2. 요청처리
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("수정Action 드라이버로딩완료");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","java1234");
	System.out.println("수정Action conn완료 : " +conn);

	// 2.1 중복검사
	String sql1 = "SELECT dept_name from departments where dept_name = ?";
	PreparedStatement stmt1 = conn.prepareStatement(sql1);
	stmt1.setString(1, dept.deptName);
	ResultSet rs = stmt1.executeQuery();
	if(rs.next()){
		String msg = URLEncoder.encode("이미 존재하는 부서번호(or부서이름) 입니다","utf-8");
		System.out.println(msg);
		response.sendRedirect(request.getContextPath()+"/dept/updateDeptForm.jsp?msg="+msg);
		return;
	}
	
	// 2.2 입력
	String sql2 = "update departments set dept_name=? where dept_no=?";
	PreparedStatement stmt2 = conn.prepareStatement(sql2);
	System.out.println("수정Action 쿼리생성 stmt : "+stmt2);
	stmt2.setString(1, dept.deptName);
	stmt2.setString(2, dept.deptNo);
	
	int row = stmt2.executeUpdate();
	if(row == 1){
		System.out.println("수정성공");
	} else {
		System.out.println("수정실패");
	}
	
	// 3. 출력
	response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp");
%>