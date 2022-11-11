<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="vo.*"%>
<%
	//1
	request.setCharacterEncoding("utf-8"); // 한글 인코딩
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	// 댓글 페이징에 사용할 현재 페이지
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}

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
	int rowPerPage = 5;
	int beginRow = (currentPage-1)*rowPerPage;
	
	String commentSql = "SELECT comment_no commentNo, comment_content commentContent FROM comment WHERE board_no = ? ORDER BY comment_no DESC LIMIT ?,?";
	PreparedStatement commentStmt = conn.prepareStatement(commentSql);
	commentStmt.setInt(1, boardNo);
	commentStmt.setInt(2, beginRow);
	commentStmt.setInt(3, rowPerPage);
	ResultSet commentRs = commentStmt.executeQuery();
	ArrayList<Comment> commentList = new ArrayList<Comment>();
	while(commentRs.next()){ 
		Comment c = new Comment();
		c.commentNo = commentRs.getInt("commentNo");
		c.commentContent = commentRs.getString("commentContent");
		commentList.add(c);
	}
	
	// 2-3 댓글 전체행의 수 -> lastPage
	String cntSql = "SELECT COUNT(*) FROM comment";
	PreparedStatement cntStmt = conn.prepareStatement(cntSql);
	ResultSet cntRs = cntStmt.executeQuery();
	int cnt = 0;
	if(cntRs.next()){
		cnt = cntRs.getInt("COUNT(*)");
	}
	int lastPage = cnt / rowPerPage;
	if(cnt % rowPerPage != 0){
		lastPage = lastPage + 1;
	}
	// 3 출력
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
				<th>Edit</th>
				<th>Delete</th>
			</tr>
		<%
			for(Comment c : commentList) {
				if(c.commentContent != null){
		%>
					<tr>
						<td><%=c.commentNo%></td>
						<td style="width:700px"><%=c.commentContent%></td>
						<td><a class="btn btn-outline-secondary btn-sm" href="<%=request.getContextPath()%>/board/updateCommentForm.jsp?commentNo=<%=c.commentNo%>&boardNo=<%=boardNo%>">수정</a></td>
						<td><a class="btn btn-outline-secondary btn-sm" href="<%=request.getContextPath()%>/board/deleteCommentForm.jsp?commentNo=<%=c.commentNo%>&boardNo=<%=boardNo%>">삭제</a></td>
					</tr>
		<%
				} 	
			}
		%>
		</table>
		<!-- 댓글 페이징 -->
			<ul class="pagination justify-content-center">
				<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo%>&currentPage=1">첫페이지</a></li>
				<%
					if(currentPage > 1){
				%>
						<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo%>&currentPage=<%=currentPage-1%>">이전</a></li>
				<%
					}
					if((currentPage>lastPage-1)&&(currentPage-3>1)){
				%>
						<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo%>&currentPage=<%=currentPage-2%>"><%=currentPage-2%></a></li>
				<%
					}
					if((currentPage>lastPage-2)&&(currentPage-2>1)){
				%>
						<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo%>&currentPage=<%=currentPage-2%>"><%=currentPage-2%></a></li>
				<%
					}
					if(currentPage-1>1){
				%>
						<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo%>&currentPage=<%=currentPage-2%>"><%=currentPage-2%></a></li>
				<%
					}
					if(currentPage>1){
				%>
						<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo%>&currentPage=<%=currentPage-1%>"><%=currentPage-1%></a></li>
				<%
					}	
				%>	<!-- 현재페이지 -->
					<li class="page-item"><span class="page-link text-warning bg-dark"><%=currentPage%></span></li>
				<%
					if(currentPage<lastPage){
				%>
						<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo%>&currentPage=<%=currentPage+1%>"><%=currentPage+1%></a></li>
				<%
					}
					if(currentPage+1<lastPage){
				%>
						<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo%>&currentPage=<%=currentPage+2%>"><%=currentPage+2%></a></li>
				<%
					}
					if(currentPage<3&&currentPage+2<lastPage){
				%>
						<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo%>&currentPage=<%=currentPage+3%>"><%=currentPage+3%></a></li>
				<%
					}
					if(currentPage<2&&currentPage+3<lastPage){
				%>
						<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo%>&currentPage=<%=currentPage+4%>"><%=currentPage+4%></a></li>
				<%
					}
					if(currentPage < lastPage) {
				%>
						<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo%>&currentPage=<%=currentPage+1%>">다음</a></li>
				<%
					}
				%>
				<li class="page-item"><a class="page-link bg-secondary text-light" href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo%>&currentPage=<%=lastPage%>">마지막페이지</a></li>
			</ul>
	</div>
</body>
</html>