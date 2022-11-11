<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="vo.*"%>
<%
	//1
	request.setCharacterEncoding("utf-8"); // 한글 인코딩
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));

	// 2.
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","java1234");
	
	// 2-1 게시글 데이터 쿼리
	String boardSql = "SELECT board_title boardTitle, board_content boardContent, board_writer boardWriter, createdate FROM board WHERE board_no = ?";
	PreparedStatement boardStmt = conn.prepareStatement(boardSql);
	boardStmt.setInt(1, boardNo);
	ResultSet boardRs = boardStmt.executeQuery();
	Board board = null;
	if(boardRs.next()) {
		board = new Board();
		board.boardNo = boardNo;
		board.boardTitle = boardRs.getString("boardTitle");
		board.boardContent = boardRs.getString("boardContent");
		board.boardWriter = boardRs.getString("boardWriter");
		board.createdate = boardRs.getString("createdate");
	}
	
	// 댓글 ORDER BY comment_no DESC (거꾸로 출력)
	// 댓글도 페이징 필요 (LIMIT ?,?)
	
	// 2-2 댓글 목록 데이터 쿼리
	
	String commentSql = "SELECT comment_no commentNo, comment_content commentContent FROM comment WHERE board_no = ? ORDER BY comment_no DESC";
	PreparedStatement commentStmt = conn.prepareStatement(commentSql);
	commentStmt.setInt(1, boardNo);
	ResultSet commentRs = commentStmt.executeQuery();
	ArrayList<Comment> commentList = new ArrayList<Comment>();
	while(commentRs.next()){ 
		Comment c = new Comment();
		c.commentNo = commentRs.getInt("commentNo");
		c.commentContent = commentRs.getString("commentContent");
		commentList.add(c);
	}
	
	// 2-3 댓글목록 페이징
	final int ROW_PER_PAGE = 10;
	
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
	
	<!-- 댓글 -->
	
	<div class="container bg-light rounded">
		<!-- 댓글입력 폼 -->
		<h3 class="container text-center rounded bg-dark text-warning">댓글입력</h3>
		<div>
			<!-- msg 파라메타값이 있으면 출력 -->
		<%
			  if(request.getParameter("msg") != null){
		%>
				<div class="text-center" style="color:red"><%=request.getParameter("msg")%></div>		
		<%		
			  }
		%>
		</div>
		<form method="post" action="<%=request.getContextPath()%>/board/insertCommentAction.jsp">
			<input type="hidden" name="boardNo" value="<%=board.boardNo%>">
			<table class="table table-hover">
				<tr>
					<td>내용</td>
					<td><textarea cols="80" rows="3" name="commentContent"></textarea></td>
				</tr>
				<tr>
					<td>비밀번호</td>
					<td><input type="password" name="commentPw"></td>
				</tr>
			</table>
			<div style="text-align:right">
				<button class="btn btn-secondary" type="submit">등록</button>
			</div>
		</form>
	</div>
	<br>
	<div class="container bg-light rounded">
		<!-- 댓글 목록 -->
		<h2 class="container text-center rounded bg-dark text-warning">- 댓글 List -</h2>	
		<table class="table">
			<tr>
				<th>No</th>
				<th style="width:700px">Comment</th>
				<th>수정</th>
				<th>삭제</th>
			</tr>
		<%
			for(Comment c : commentList) {
		%>
				<tr>
					<td><%=c.commentNo%></td>
					<td style="width:700px"><%=c.commentContent%></td>
					<td><a class="btn btn-outline-secondary btn-sm" href="">수정</a></td>
					<td><a class="btn btn-outline-secondary btn-sm" href="">삭제</a></td>
				</tr>
		<%		
			}
		%>
		</table>
	</div>
</body>
</html>