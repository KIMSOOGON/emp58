<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="vo.*"%>
<%
	// 1. 요청분석
	request.setCharacterEncoding("utf-8"); // 한글 인코딩
	String boardNo = request.getParameter("boardNo"); // boardNo 받아오기
	
	// 2. 업무처리
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("1) updateBoardForm 드라이버로딩완료");
	Connection conn = DriverManager.getConnection(
			"jdbc:mariadb://localhost:3306/employees","root","java1234");
	System.out.println("2) updateBoardForm Connection 완료 :"+conn);
	
	String sql = "SELECT board_pw boardPw, board_title boardTitle, board_content boardContent, board_writer boardWriter FROM board where board_no = ?";
	// board 번호로 부터 암호, 제목, 내용, 작성자 골라오기
	PreparedStatement stmt = conn.prepareStatement(sql);
	System.out.println("3) updateBoardForm stmt :"+stmt);	

	stmt.setString(1,boardNo);
	ResultSet rs = stmt.executeQuery(); // 쿼리 실행
	
	Board b = new Board();
	b.boardNo = 0;
	b.boardPw = null;
	b.boardTitle = null;
	b.boardContent = null;
	b.boardWriter = null;
	
	if(rs.next()){
		b.boardNo = Integer.parseInt(boardNo);
		b.boardPw = rs.getString("boardPw");
		b.boardTitle = rs.getString("boardTitle");
		b.boardContent = rs.getString("boardContent");
		b.boardWriter = rs.getString("boardWriter");
	}
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>UpdateBoardForm</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body style="background-color:rgb(200,200,205)">
		<!-- 메뉴 partial jsp 구성 -->
	<div>
		<jsp:include page="../inc/menu.jsp"></jsp:include>
	</div>
	
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
	
	<div class="container mt-4 p-4 bg-light text-center">
		<h2 class="container mt-3 p-3 bg-dark text-warning">게시글 수정</h2>
		<form method="post" action="<%=request.getContextPath()%>/board/updateBoardAction.jsp">
			<table class="table talbe-hover">
				<tr>	
					<td><mark>1) 글번호</mark></td>
					<td><input type="text" name="boardNo" value="<%=b.boardNo%>" readonly="readonly"></td>
				</tr>
				 
				<tr>	
					<td><mark>2) 제목</mark></td>
					<td><input type="text" name="boardTitle" value="<%=b.boardTitle%>"></td>
				</tr>
				<tr>	
					<td><mark>3) 내용</mark></td>
					<td><textarea rows="10" cols="50" name="boardContent"><%=b.boardContent%></textarea></td>
				</tr>
				<tr>	
					<td><mark>4) 작성자</mark></td>
					<td><input type="text" name="boardWriter" value="<%=b.boardWriter%>" readonly="readonly"></td>
				</tr>
				<tr>	
					<td><mark>5) 암호를 입력하세요</mark></td>
					<td><input type="password" name="boardPw"></td>
				</tr>
				<tr>
					<td colspan="2">
						<button class="btn btn-warning text-center" type="submit">수정</button>
					</td>
				</tr>
			</table>
		</form>
	</div>
</body>
</html>