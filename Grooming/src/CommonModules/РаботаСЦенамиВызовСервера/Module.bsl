Функция ПолучитьЦенуПродажиНаДату(Номенклатура, ВидЦены = Неопределено, ДатаЦены = Неопределено) Экспорт
	Если ВидЦены = Неопределено Тогда
		ВидЦены = Перечисления.ВидЦены.Розничная;
	КонецЕсли;   
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ЦеныНоменклатурыСрезПоследних.Номенклатура КАК Номенклатура,
	|	ЦеныНоменклатурыСрезПоследних.Цена КАК Цена
	|ИЗ
	|	РегистрСведений.ЦеныНоменклатуры.СрезПоследних(
	|			&Период,
	|			Номенклатура = &Номенклатура
	|				И ВидЦены = &ВидЦены) КАК ЦеныНоменклатурыСрезПоследних"; 
	
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура); 
	Запрос.УстановитьПараметр("ВидЦены", ВидЦены);
	Запрос.УстановитьПараметр("Период", ДатаЦены);
	
	РезультатЗапроса = Запрос.Выполнить(); 
	
	Если РезультатЗапроса.Пустой() Тогда
		Сообщить("В базе данных не найдены цены для данной номенклатуры!");
		возврат 0;
	КонецЕсли; 
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	Возврат Выборка.Цена;
	
КонецФункции     


Функция ПолучитьЗаписьЦеныНаКонкретнуюДату(Номенклатура, ВидЦены, ДатаЦены) Экспорт		Запрос = Новый Запрос;	Запрос.Текст = "ВЫБРАТЬ	|    ЦеныНоменклатуры.Цена КАК Цена	|ИЗ	|    РегистрСведений.ЦеныНоменклатуры КАК ЦеныНоменклатуры	|ГДЕ	|    ЦеныНоменклатуры.Период = &Период	|    И ЦеныНоменклатуры.Номенклатура = &Номенклатура	|    И ЦеныНоменклатуры.ВидЦены = &ВидЦены";		Запрос.УстановитьПараметр("Номенклатура", Номенклатура);	Запрос.УстановитьПараметр("Период", ДатаЦены);	Запрос.УстановитьПараметр("ВидЦены", ВидЦены);		РезультатЗапроса = Запрос.Выполнить();		Если РезультатЗапроса.Пустой() Тогда		возврат 0;	КонецЕсли;		Выборка = РезультатЗапроса.Выбрать();		Выборка.Следующий();		возврат Выборка.Цена;	КонецФункции