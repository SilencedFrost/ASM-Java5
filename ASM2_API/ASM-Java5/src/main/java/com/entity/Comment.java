package com.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "Comments")
@Getter
@Setter
@NoArgsConstructor
public class Comment {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "CommentId")
	private Long commentId;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "UserId", nullable = false)
	private User user;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ProductId", nullable = false)
	private Product product;

	@Column(name = "CommentDate", nullable = false)
	private LocalDateTime commentDate;

	@Column(name = "CommentContent", nullable = false, length = 500)
	private String commentContent;

	public void setUser(User user) {
		if (this.user != null) {
			this.user.getComments().remove(this);
		}

		this.user = user;

		if (user != null) {
			user.getComments().add(this);
		}
	}

	public void setProduct(Product product) {
		if (this.product != null) {
			this.product.getComments().remove(this);
		}

		this.product = product;

		if (product != null) {
			product.getComments().add(this);
		}
	}

	@PrePersist
	protected void onCreate() {
		this.commentDate = LocalDateTime.now();
	}

	public Comment(User user, Product product, String commentContent) {
		setUser(user);
		setProduct(product);
		this.commentContent = commentContent;
	}
}
