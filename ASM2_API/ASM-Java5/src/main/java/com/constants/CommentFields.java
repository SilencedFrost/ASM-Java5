package com.constants;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum CommentFields implements Automatable {
    COMMENT_ID("commentId"),
    USER_ID("userId"),
    PRODUCT_ID("productId"),
    COMMENT_DATE("commentDate"),
    COMMENT_CONTENT("commentContent");

    private final String propertyKey;
}
