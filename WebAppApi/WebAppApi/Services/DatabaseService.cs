using System.Data;
using Npgsql;

namespace WebAppApi.Services
{
    public class DatabaseService
    {
        NpgsqlDataSource _dataSource;
        public DatabaseService(NpgsqlDataSource dataSource)
        {
            _dataSource = dataSource;
        }

        public async Task<DataTable> ExecuteQueryAsync(string sqlQuery)
        {
            DataTable retval = new DataTable();

            await using var command = _dataSource.CreateCommand(sqlQuery);
            await using (NpgsqlDataReader reader = await command.ExecuteReaderAsync())
            {
                retval.Load(reader);
            };

            return retval;
        }

        public static List<Dictionary<string, object>> ToDictionaryList(DataTable table)
        {
            var list = new List<Dictionary<string, object>>();

            foreach (DataRow row in table.Rows)
            {
                var dict = new Dictionary<string, object>();
                foreach (DataColumn col in table.Columns)
                {
                    dict[col.ColumnName] = row[col];
                }
                list.Add(dict);
            }

            return list;
        }
    }
}
