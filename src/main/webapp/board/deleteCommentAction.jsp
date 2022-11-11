<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="vo.*"%>
<%@ page import = "java.net.URLEncoder"%>
<%
	// 1. 요청분석
	request.setCharacterEncoding("utf-8");
	
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	String commentPw = request.getParameter("commentPw");
	
	
	if(commentPw==null||commentPw.equals("")){ 
		String msg1 = URLEncoder.encode("패스워드를 입력하세요","utf-8");
		response.sendRedirect(request.getContextPath()+"/board/deleteCommentForm.jsp?msg1="+msg1+"&commentNo="+commentNo+"&boardNo="+boardNo);
		return;
	}
	
	// 2. 업무처리
	// 드라이브 로딩 및 접속
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("1) 댓글삭제 드라이버로딩 완료");
	
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","java1234");
	System.out.println("2) 댓글삭제 접속완료 conn:"+conn);
	
	// 쿼리문 생성 및 실행하기
	String sql = "DELETE FROM comment where board_no = ? AND comment_no = ? AND comment_pw = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, boardNo);
	stmt.setInt(2, commentNo);
	stmt.setString(3, commentPw);
	
	int row = stmt.executeUpdate();
	if(row==1){
		System.out.println("댓글삭제완료");
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo+"&commentNo="+commentNo);
	} else if(row!=1&&commentPw!=null&&!commentPw.equals("")){
		String msg2 = URLEncoder.encode("패스워드가 잘못되었습니다","utf-8");
		response.sendRedirect(request.getContextPath()+"/board/deleteCommentForm.jsp?msg2="+msg2+"&boardNo="+boardNo+"&commentNo="+commentNo);
	}
%>