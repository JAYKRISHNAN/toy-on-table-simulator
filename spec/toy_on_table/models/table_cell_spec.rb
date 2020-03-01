# frozen_string_literal: true

require_relative '../../../lib/toy_on_table/models/table_cell'

describe ToyOnTable::Models::TableCell do
  describe '.initialize' do
    it 'sets x and y coordinate' do
      cell = ToyOnTable::Models::TableCell.new(2, 3)

      expect(cell.x_coordinate).to eq 2
      expect(cell.y_coordinate).to eq 3
    end
  end

  it 'has aliases row_number and column number for x and y coordinates respectively' do
    cell = ToyOnTable::Models::TableCell.new(2, 3)

    expect(cell.row_number).to eq 2
    expect(cell.column_number).to eq 3
  end
end
