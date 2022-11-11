<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*"%>
<%@ page import = "vo.*" %>
<%@ page import = "java.net.URLEncoder"%>
<%
	//1. 요청분석(Controller)
	request.setCharacterEncoding("utf-8");
	String boardNo = request.getParameter("boardNo");
	String boardPw = request.getParameter("boardPw");
	System.out.println(boardPw); // 디버깅
	
	// 2. 업무처리(Model)
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("1) deleteBoard 드라이버 로딩 완료");
	
	Connection conn = DriverManager.getConnection(
			"jdbc:mariadb://localhost:3306/employees","root","java1234");
	System.out.println("2) deleteBoard 접속완료 conn : " + conn);
	
	// 2.1 패스워드 검사
	String pwSql = "SELECT board_pw FROM board where board_no =? AND board_pw = ?";
	PreparedStatement pwStmt = conn.prepareStatement(pwSql);
	pwStmt.setString(1, boardNo);
	pwStmt.setString(2, boardPw);
	
	ResultSet pwRs = pwStmt.executeQuery();
	if(pwRs.next()!=true){
		String msg = URLEncoder.encode("비밀번호가 틀렸습니다.","utf-8");
		response.sendRedirect(request.getContextPath()+"/board/deleteBoardForm.jsp?msg="+msg+"&boardNo="+boardNo);
		return;
	}
	
	/*
	int row = 0;
	if(row == 1){
		response.sendRedirect(request.getContextPath()+"/board/boardList.jsp");
	} else {
		String msg = URLEncoder.encode("비밀번호를 확인하세요", "utf-8")
		response.sendRedirect(request.getContextPath()+"/board/deleteBoardForm.jsp?msg="+msg);
	}
	*/
	
	// 2.2 삭제 쿼리
	String sql = "delete from board where board_no = ? AND board_pw = ?";
	System.out.println("3) deleteBoard sql : "+sql);
	
	PreparedStatement stmt = conn.prepareStatement(sql);
	System.out.println("4) deleteBoard stmt : "+stmt);
	stmt.setString(1,boardNo);
	stmt.setString(2,boardPw);
	
	int row = stmt.executeUpdate();
	if(row == 1){
		System.out.println("삭제완료");
	} else {
		System.out.println("삭제실패");
	}
	/*
	int row = stmt.executeUpdate();
	if(row==1){
		System.out.println("삭제완료");
	} else {
		System.out.println("삭제실패");
	}
	*/
	
	// 3. 출력
	response.sendRedirect(request.getContextPath()+"/board/boardList.jsp");
%>