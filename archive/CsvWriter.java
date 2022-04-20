import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.List;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import com.consensusapps.ingestor.model.AddressTag;
import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.ObjectWriter;
import com.fasterxml.jackson.dataformat.csv.CsvMapper;
import com.fasterxml.jackson.dataformat.csv.CsvSchema;

public class CsvWriter {

  public static void main(String[] args) {

    String filePath = null;
    while (true) {
      try {
        System.out.print("Enter csv file path:");
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        filePath = reader.readLine();

        if (null != filePath && !filePath.isBlank()) {

          if (!new File(filePath).createNewFile()) {
            System.out.println(
                "Not able to create file on a given path or file already exist with given name. Enter correct file path");
          } else {
            break;
          }
        } else {
          System.out.println("Invalid file path specified. Enter correct file path");
        }
      } catch (Exception ex) {
        ex.printStackTrace();
      }
    }

    CsvWriter instance = new CsvWriter();
    instance.scrapAccountsForTags(filePath);
  }

  public void scrapAccountsForTags(String filePath) {
    for (int start = 1; start <= 100; start++) {
      String webUrl = "https://etherscan.io/accounts/" + start + "?ps=100";
      try {
        System.out.println("Scraping the web url:" + webUrl);
        List<AddressTag> addressTags = new ArrayList<AddressTag>();
        Document document = Jsoup.connect(webUrl).userAgent("Mozilla/5.0").timeout(5000).get();
        Elements tables = document.getElementsByClass("table table-hover");
        for (Element table : tables) {
          Elements tableRows = table.getElementsByTag("tr");
          if (null != tableRows && tableRows.size() > 0) {
            for (Element tableRow : tableRows) {
              Elements tableData = tableRow.getElementsByTag("td");
              if (null != tableData && tableData.size() > 0 && !tableData.get(2).text().isBlank()) {
                addressTags.add(
                    new AddressTag(null, tableData.get(2).text(), tableData.get(1).text()));
              }
            }
          }
        }
        writeDataToCsv(filePath, addressTags, start == 1);
      } catch (IOException ioex) {
        ioex.printStackTrace();
      }
    }
  }

  private void writeDataToCsv(String filePath, List<AddressTag> addressTags, boolean isFirstPage) {
    System.out.println("Writing of " + filePath + " file started");

    try {
      CsvMapper mapper = new CsvMapper();
      mapper.configure(JsonGenerator.Feature.IGNORE_UNKNOWN, true);
      CsvSchema schema = CsvSchema.builder().setUseHeader(isFirstPage).addColumn("address")
          .addColumn("tag")
          .build();

      ObjectWriter writer = mapper.writer(schema);
      OutputStream outstream = new FileOutputStream(new File(filePath), true);
      writer.writeValue(outstream, addressTags);
    } catch (IOException ioex) {
      ioex.printStackTrace();
    }
    System.out.println(
        "Writing of " + filePath + " file completed with " + addressTags.size() + " records");
  }
}