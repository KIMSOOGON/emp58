<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import = "java.util.*"%>
<%@ page import = "vo.*" %>
<%@ page import = "java.net.URLEncoder"%>
<%
	// 1. 요청분석
	request.setCharacterEncoding("utf-8");
	String boardNo = request.getParameter("boardNo");
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	String boardWriter = request.getParameter("boardWriter");
	String boardPw = request.getParameter("boardPw");
	
	Board b = new Board();
	b.boardNo = Integer.parseInt(boardNo);
	b.boardPw = boardPw;
	b.boardTitle = boardTitle;
	b.boardContent = boardContent;
	b.boardWriter = boardWriter;
	
	if(b.boardTitle==null || b.boardPw == null || b.boardContent==null || b.boardWriter==null
		|| b.boardTitle=="" || b.boardPw =="" || b.boardContent=="" || b.boardWriter==""){     
      response.sendRedirect(request.getContextPath()+"/board/updateBoardForm.jsp");
      return;
   	}
	
	
	// 2. 업무처리
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("1) updateBoardAction 드라이버로딩완료");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","java1234");
	System.out.println("2) updateBoardAction conn완료 : "+conn);
	
	
	// 2.1 패스워드 검사
	String pwSql = "SELECT board_pw FROM board where board_no =? AND board_pw = ?";
	PreparedStatement pwStmt = conn.prepareStatement(pwSql);
	pwStmt.setInt(1, b.boardNo);
	pwStmt.setString(2, b.boardPw);
	
	ResultSet pwRs = pwStmt.executeQuery();
	if(pwRs.next()!=true){
		String msg = URLEncoder.encode("비밀번호가 틀렸습니다.","utf-8");
		response.sendRedirect(request.getContextPath()+"/board/updateBoardForm.jsp?msg="
		+msg+"&boardNo="+b.boardNo+"&boardTitle="+b.boardTitle);
		return;
	}
	System.out.println("비밀번호가 일치합니다");
	
	// 2.2 수정
	String sql = "UPDATE board set board_title=?, board_content=? WHERE board_no = ? AND board_pw = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	
	stmt.setString(1, b.boardTitle);
	stmt.setString(2, b.boardContent);
	stmt.setInt(3, b.boardNo);
	stmt.setString(4, b.boardPw);
	
	int row = stmt.executeUpdate();
	if(row == 1){
		System.out.println("수정성공");
	} else {
		System.out.println("수정실패");
	}
	
	// 3. 출력
	response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+b.boardNo);
%>