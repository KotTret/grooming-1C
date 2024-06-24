#Область ОбработчикиСобытийФормы
&НаКлиенте
Процедура ПриОткрытии(Отказ)

	Если Не ЗначениеЗаполнено(Объект.Наименование) Тогда

		СформироватьФИО();

	КонецЕсли;

КонецПроцедуры
#КонецОбласти
#Область ОбработчикиСобытийЭлементовШапкиФормы
&НаКлиенте
Процедура ФамилияПриИзменении(Элемент)
	СформироватьФИО();
КонецПроцедуры

&НаКлиенте
Процедура ИмяПриИзменении(Элемент)
	СформироватьФИО();

КонецПроцедуры

&НаКлиенте
Процедура ОтчествоПриИзменении(Элемент)
	СформироватьФИО();

КонецПроцедуры
#КонецОбласти
#Область СлужебныеПроцедурыИФункции
&НаКлиенте
Процедура СформироватьФИО()

	Объект.Наименование = Объект.Фамилия + " " + Объект.Имя + " " + Объект.Отчество;

КонецПроцедуры
#КонецОбласти