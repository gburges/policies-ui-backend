package com.redhat.cloud.policies.app.lightweight;

import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;
import javax.persistence.EntityManager;
import javax.transaction.Transactional;
import java.time.LocalDateTime;

import static java.time.ZoneOffset.UTC;

@ApplicationScoped
public class AccountLatestUpdateRepository {

    @Inject
    EntityManager entityManager;

    @Transactional
    public void setLatestToNow(String accountId) {
        String sql = "INSERT INTO account_latest_update (account_id, latest) SELECT :accountId, :latest " +
                "ON CONFLICT (account_id) DO UPDATE SET latest = :latest";
        entityManager.createNativeQuery(sql)
                .setParameter("accountId", accountId)
                .setParameter("latest", LocalDateTime.now(UTC))
                .executeUpdate();
    }
}
