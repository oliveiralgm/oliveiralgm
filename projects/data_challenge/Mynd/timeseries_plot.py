import matplotlib.pyplot as plt

# Occupancy rate
df_occ = run_query('''
SELECT strftime('%Y-%m', onboard_date) AS month,
       CAST(SUM(CASE WHEN offboard_date IS NULL THEN 1 ELSE 0 END) AS float) / COUNT(*) AS occupancy_rate
FROM properties
GROUP BY strftime('%Y-%m', onboard_date)
''')
df_occ.set_index('month')['occupancy_rate'].plot()
plt.title('Occupancy rate')
plt.ylabel('Occupancy rate')
plt.show()

# Renewal rate
df_ren = run_query('''
SELECT strftime('%Y-%m', end_date) AS month,
       CAST(SUM(CASE WHEN renew_id IS NOT NULL THEN 1 ELSE 0 END) AS float) / COUNT(*) AS renewal_rate
FROM (
  SELECT *,
         (SELECT MIN(start_date) FROM contracts c2 WHERE c2.tenant_id = c1.tenant_id AND c2.start_date > c1.end_date) AS renew_date,
         (SELECT contract_id FROM contracts c2 WHERE c2.tenant_id = c1.tenant_id AND c2.start_date = renew_date) AS renew_id
  FROM contracts c1
) c
JOIN properties p ON p.property_id = c.property_id
GROUP BY strftime('%Y-%m', end_date)
''')
df_ren.set_index('month')['renewal_rate'].plot()
plt.title('Renewal rate')
plt.ylabel('Renewal rate')
plt.show()
