<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>;
<%@ page import = "java.net.URLEncoder"%>
<%@ page import = "vo.*" %>
<%
	// 1. 요청분석
	request.setCharacterEncoding("utf-8");
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	int boardNo = Integer.parseInt(request.getParameter("boardNo")); 
	String commentContent = request.getParameter("commentContent"); 
	String commentPw = request.getParameter("commentPw");
	
	Comment c = new Comment();
	c.commentNo = commentNo;
	c.boardNo = boardNo;
	c.commentContent = commentContent;
	c.commentPw = commentPw;
	
	// 내용 공백일 시, 돌려보내기
	if(c.commentContent==null||c.commentContent.equals("")&&c.commentPw!=null&&!c.commentPw.equals("")){
		String contentMsg = URLEncoder.encode("내용을 입력하세요","utf-8");
		response.sendRedirect(request.getContextPath()+"/board/updateCommentForm.jsp?contentMsg="+contentMsg+"&boardNo="+boardNo+"&commentNo="+commentNo);
		return;
	}
	
	// 2. 업무처리
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("1) updateCommentAction 드라이버로딩완료"); // 디버깅
	Connection conn = DriverManager.getConnection(
			"jdbc:mariadb://localhost:3306/employees","root","java1234");
	System.out.println("2) updateCommentAction Connection 완료 :"+conn); // 디버깅
	
	// 2.1 패스워드 검사
	String pwSql = "SELECT comment_pw FROM comment where board_no=? AND comment_no=? AND comment_pw=?";
	PreparedStatement pwStmt = conn.prepareStatement(pwSql);
	pwStmt.setInt(1, boardNo);
	pwStmt.setInt(2, commentNo);
	pwStmt.setString(3, commentPw);
	
	ResultSet pwRs = pwStmt.executeQuery();
	if(pwRs.next()!=true){
		String failMsg = URLEncoder.encode("패스워드를 다시 입력해주세요","utf-8");
		response.sendRedirect(request.getContextPath()+"/board/updateCommentForm.jsp?failMsg="+failMsg+"&boardNo="+c.boardNo+"&commentNo="+c.commentNo);
		return;
	} 
	
	// 2.2 수정 진행
	String sql = "UPDATE comment set comment_content=? WHERE board_no = ? AND comment_no=? AND comment_pw= ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	
	stmt.setString(1, c.commentContent);
	stmt.setInt(2, c.boardNo);
	stmt.setInt(3, c.commentNo);
	stmt.setString(4, c.commentPw);
	
	int row = stmt.executeUpdate();
	if(row == 1){
		System.out.println("수정성공");
	} else {
		System.out.println("수정실패");
	}
	
	// 3. 출력
	response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+c.boardNo);
%>