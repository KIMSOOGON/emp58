<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.net.URLEncoder"%>
<%@ page import = "vo.*" %>
<%
	// 1. 요청분석
	request.setCharacterEncoding("utf-8"); // 한글 인코딩
	String deptNo = request.getParameter("deptNo");
	String deptName = request.getParameter("deptName");
	if(deptNo==null || deptName==null || deptNo.equals("") || deptName.equals("")){ // 안전장치 코드
		String msg = URLEncoder.encode("부서번호와 부서이름을 입력하세요","utf-8");
		response.sendRedirect(request.getContextPath()+"/dept/insertDeptForm.jsp?msg="+msg);
		return;
	}
	
	// 2. 요청처리
	// 이미 존재하는 key(dept_no)값 동일한 값이 입력되면 예외(에러)가 발생한다. -> 동일한 dept_no값이 입력되었을때 예외가 발생하지 않도록
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("인서트액션 드라이버성공"); // 디버깅
	Connection conn = DriverManager.getConnection(
			"jdbc:mariadb://localhost:3306/employees","root","java1234");
	System.out.println("인서트액션 conn 성공 : "+conn);
	
	// 2-1. dept_no 중복검사
	String sql1 = "SELECT dept_no, dept_name FROM departments WHERE dept_no = ? OR dept_name = ?"; // 입력하기전에 같은 dept_no가 존재하는지
	PreparedStatement stmt1 = conn.prepareStatement(sql1);
	stmt1.setString(1, deptNo);
	stmt1.setString(2, deptName);
	ResultSet rs = stmt1.executeQuery();
	if(rs.next()){ // 결과물있다 -> 같은 dept_no가 이미 존재한다.
		String msg = URLEncoder.encode("이미 존재하는 부서번호(or부서이름) 입니다","utf-8");
		response.sendRedirect(request.getContextPath()+"/dept/insertDeptForm.jsp?msg="+msg);
		return;
	}
	// 2-2. 입력
	String sql2 = "INSERT INTO departments(dept_no, dept_name) values(?,?)";
	PreparedStatement stmt2 = conn.prepareStatement(sql2);
	System.out.println("인서트액션 쿼리생성 성공");
	
	System.out.println(deptNo); // 디버깅
	System.out.println(deptName); // 디버깅
	
	stmt2.setString(1,deptNo);
	stmt2.setString(2,deptName);
	
	int row = stmt2.executeUpdate();
	if(row==1){ // 디버깅
		System.out.println("성공");
	} else {
		System.out.println("실패");
	}
	
	// 3. 출력
	response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp");
%>