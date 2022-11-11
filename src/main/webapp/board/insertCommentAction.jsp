<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="vo.*"%>
<%@ page import="java.net.URLEncoder"%>
<%
	// 1. 요청분석
	request.setCharacterEncoding("utf-8"); // 한글 인코딩
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String commentContent = request.getParameter("commentContent");
	String commentPw = request.getParameter("commentPw");
	if(commentContent==null||commentPw==null||commentContent.equals("")||commentPw.equals("")){
		String msg = URLEncoder.encode("내용 및 패스워드를 입력해주세요","utf-8");
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?msg="+msg+"&boardNo="+boardNo);
		return;
	}
	
	// 2. 업무처리
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("1) Comment Action 드라이버 완료");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","java1234");
	System.out.println("2) Coomment Action 접속완료 conn: "+conn);
	
	// 2.1 쿼리문 입력 및 실행
	String sql = "INSERT INTO comment(board_no, comment_pw, comment_content, createdate) values(?,?,?,curdate())";
	PreparedStatement stmt = conn.prepareStatement(sql);
	
	stmt.setInt(1, boardNo);
	stmt.setString(2, commentPw);
	stmt.setString(3, commentContent);
	
	int row = stmt.executeUpdate();
	if(row==1){
		System.out.println("댓글등록 완료");
	} else {
		System.out.println("댓글등록 오류");
	}
	
	// 3. 출력
	response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo);
%>