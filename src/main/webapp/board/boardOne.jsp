<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="vo.*"%>
<%
	//1
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));

	// 2
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","java1234");
	String sql = "SELECT board_title boardTitle, board_content boardContent, board_writer boardWriter, createdate FROM board WHERE board_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, boardNo);
	ResultSet rs = stmt.executeQuery();
	Board board = null;
	if(rs.next()) {
		board = new Board();
		board.boardNo = boardNo;
		board.boardTitle = rs.getString("boardTitle");
		board.boardContent = rs.getString("boardContent");
		board.boardWriter = rs.getString("boardWriter");
		board.createdate = rs.getString("createdate");
	}
	
	// 3
	
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>boardOne</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body style="background-color:rgb(200,200,205)">
		<!-- 메뉴 partial jsp 구성 -->
	<div>
		<jsp:include page="../inc/menu.jsp"></jsp:include>
	</div>
	<h2 class="container mt-3 p-3 bg-dark text-warning text-center rounded">Detail</h2>
	<div class="container mt-4 p-4 bg-light text-center">
		<table class="table table-bordered">
			<tr>
				<td>제목</td>
				<td><%=board.boardTitle%></td>
			</tr>
			<tr>
				<td>내용</td>
				<td><%=board.boardContent%></td>
			</tr>
			<tr>
				<td>작성자</td>
				<td><%=board.boardWriter%></td>
			</tr>
			<tr>
				<td>글번호</td>
				<td><%=board.boardNo%></td>
			</tr>
			<tr>
				<td>생성날짜</td>
				<td><%=board.createdate%></td>
			</tr>
		</table>
		<div style="text-align:right">
			<a class="btn btn-success btn-sm" href="<%=request.getContextPath()%>/board/updateBoardForm.jsp?boardNo=<%=board.boardNo%>">수정</a>
			<a class="btn btn-danger btn-sm" href="<%=request.getContextPath()%>/board/deleteBoardForm.jsp?boardNo=<%=board.boardNo%>">삭제</a>
		</div>
	</div>
</body>
</html>