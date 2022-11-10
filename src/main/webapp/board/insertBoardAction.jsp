<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="vo.*"%>
<%@ page import="java.net.URLEncoder"%>
<%
	// 1. 요청분석
	request.setCharacterEncoding("utf-8"); // utf-8 한글 인코딩
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	String boardWriter = request.getParameter("boardWriter");
	String boardPw = request.getParameter("boardPw");
	if(boardTitle==null || boardContent==null || boardWriter==null || boardPw==null){
		String msg = URLEncoder.encode("누락된 항목이 있습니다", "utf-8");
		response.sendRedirect(request.getContextPath()+"/insertBoardForm.jsp?msg="+msg);
		return;
	}
	
	// 2. 업무처리
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("1) insertBoardAction 드라이브 로딩 完"); // 디버깅
	
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","java1234");
	System.out.println("2) insertBoardAction 접속완료 Conn = "+conn); // 디버깅
	
	String sql = "INSERT INTO board(board_pw, board_title, board_content, board_writer, createdate) values(?,?,?,?,curdate())";
	PreparedStatement stmt = conn.prepareStatement(sql);
	
	stmt.setString(1,boardPw);
	stmt.setString(2,boardTitle);
	stmt.setString(3,boardContent);
	stmt.setString(4,boardWriter);

	int row = stmt.executeUpdate();
	if(row==1){
		System.out.println("성공");
	} else {
		System.out.println("실패");
	}
	
	// 3. 출력
	response.sendRedirect(request.getContextPath()+"/board/boardList.jsp");
%>