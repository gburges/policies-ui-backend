/*
 * Copyright 2020 Red Hat, Inc. and/or its affiliates
 * and other contributors as indicated by the @author tags.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.redhat.cloud.policies.app.model.pager;

import com.redhat.cloud.policies.app.model.filter.Filter;
import io.quarkus.panache.common.Sort;
import io.smallrye.common.constraint.Nullable;

public class Pager {

    public static final int NO_LIMIT = -1;

    private final int offset;
    private final int limit;
    @Nullable
    private final Sort sort;
    private final Filter filter;

    public Pager(int offset, int limit, Filter filter, Sort sort) {
        this.offset = offset;
        this.limit = limit;
        this.filter = filter;
        this.sort = sort;
    }

    public int getOffset() {
        return offset;
    }

    public int getLimit() {
        return limit;
    }

    public Filter getFilter() {
        return new Filter(filter);
    }

    public Sort getSort() {
        return sort;
    }

    public static PagerBuilder builder() {
        return new PagerBuilder();
    }

    public static class PagerBuilder {

        private int offset;
        private int limit;
        private final Sort sort;
        private final Filter filter;

        private PagerBuilder() {
            this.offset = 0;
            this.limit = 50;
            this.sort = Sort.by();
            this.filter = new Filter();
        }

        public PagerBuilder page(int offset) {
            this.offset = offset;
            return this;
        }

        public PagerBuilder itemsPerPage(int limit) {
            this.limit = limit;
            return this;
        }

        public PagerBuilder addSort(String column, Sort.Direction direction) {
            this.sort.and(column, direction);
            return this;
        }

        public PagerBuilder filter(String column, Filter.Operator operator, String value) {
            Object transformedValue = value;
            if (operator.equals(Filter.Operator.BOOLEAN_IS)) {
                transformedValue = Boolean.valueOf(value);
            }

            this.filter.and(column, operator, transformedValue);
            return this;
        }

        public Pager build() {
            Filter filter = new Filter(this.filter);
            return new Pager(this.offset, this.limit, filter, this.sort);
        }

    }

}
